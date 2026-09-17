import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/converter/game_task_queue_converter.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/converter/player_map_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
sealed class GameState with _$GameState {
  const factory GameState({
    @PlayerMapConverter() required Map<PlayerId, PlayerState> players,
    required GamePhase phase,
    required int turnCount,
    required PlayerId initialTurnOwner,
    @GameTaskQueueConverter() required QueueList<GameTask> taskQueue,
    required SystemMetadata metadata,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

extension GameStateEx on GameState {
  GameState incrementalActionSequence() {
    return copyWith(
      metadata: metadata.copyWith(
        actionSequenceNumber: metadata.actionSequenceNumber + 1,
      ),
    );
  }

  PlayerState? get currentTurnOwner => players[phase.turnOwner];

  GameState clearShield(PlayerId targetId) {
    final targetPlayer = players[targetId];
    if (targetPlayer == null) return this;

    return copyWith(
      players: {
        ...players,
        targetId: targetPlayer.copyWith(shield: 0),
      },
    );
  }

  GameState nextTurn() {
    final nextOwner = players.keys.firstWhere(
      (id) => id != phase.turnOwner,
    );

    return copyWith(
      turnCount: initialTurnOwner != nextOwner ? turnCount : turnCount + 1,
      phase: phase.copyWith(
        battlePhase: BattlePhase.turnStart,
        turnOwner: nextOwner,
      ),
    );
  }

  PlayerState? getOtherPlayer(PlayerId playerId) {
    return players.entries.firstWhereOrNull((e) => e.key != playerId)?.value;
  }

  GameCard? findGameCard({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
  }) => players[playerId]?.hand.firstWhereOrNull(
    (gameCard) => gameCard.instanceId == instanceId,
  );

  GameCard? findPlayedCardInAllZone({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
  }) {
    for (final zone in CardZone.values) {
      final card = findGameCardInZone(
        playerId: playerId,
        instanceId: instanceId,
        zone: zone,
      );
      if (card != null) return card;
    }
    return null;
  }

  GameCard? findGameCardInZone({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
    required CardZone zone,
  }) {
    final cards = switch (zone) {
      CardZone.deck => players[playerId]?.deck,
      CardZone.hand => players[playerId]?.hand,
      CardZone.graveyard => players[playerId]?.graveyard,
      CardZone.exhausted => players[playerId]?.exhausted,
      CardZone.playArea => players[playerId]?.playArea,
    };

    return cards?.firstWhereOrNull(
      (gameCard) => gameCard.instanceId == instanceId,
    );
  }

  GameState moveCardZone({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
    required CardZone from,
    required CardZone to,
  }) {
    final player = players[playerId];
    if (player == null) {
      return this;
    }

    final updatedPlayer = player.moveCardZone(
      instanceId,
      from,
      to,
    );

    return copyWith(
      players: {
        ...players,
        playerId: updatedPlayer,
      },
    );
  }

  GameState advanceHandCardRuntimeStates({required PlayerId playerId}) {
    final player = players[playerId];
    if (player == null) return this;

    final updatedHand = player.hand.map((card) {
      final updatedRuntimeStates = card.runtimeStates.map((state) {
        return switch (state) {
          CardRuntimeStateCountdownState(:final remainingTurns) =>
            state.copyWith(
              remainingTurns: remainingTurns > 0 ? remainingTurns - 1 : 0,
            ),
          CardRuntimeStateDecayState(:final remainingTurns) => state.copyWith(
            remainingTurns: remainingTurns > 0 ? remainingTurns - 1 : 0,
          ),
          CardRuntimeStateRetainState(:final turnsInHand) => state.copyWith(
            turnsInHand: turnsInHand + 1,
          ),
          _ => state,
        };
      }).toList();

      return card.copyWith(runtimeStates: updatedRuntimeStates);
    }).toList();

    final updatedPlayer = player.copyWith(hand: updatedHand);
    return copyWith(
      players: {...players, playerId: updatedPlayer},
    );
  }

  GameState decrementRecycleCount({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
  }) {
    final player = players[playerId];
    if (player == null) return this;

    final updatedHand = player.hand.map((card) {
      if (card.instanceId != instanceId) return card;

      final updatedRuntimeStates = card.runtimeStates.map((state) {
        if (state is CardRuntimeStateRecycleState) {
          final currentCount = state.remainingCount;
          return state.copyWith(
            remainingCount: currentCount > 0 ? currentCount - 1 : 0,
          );
        }
        return state;
      }).toList();

      return card.copyWith(runtimeStates: updatedRuntimeStates);
    }).toList();

    final updatedPlayer = player.copyWith(hand: updatedHand);
    return copyWith(
      players: {...players, playerId: updatedPlayer},
    );
  }
}

enum GameStateTaskPushPos { head, tail }

extension GameStateTaskQueueX on GameState {
  GameTask? get currentTask => taskQueue.firstOrNull;

  GameState pushTask(GameStateTaskPushPos pos, GameTask task) {
    final nextQueue = QueueList<GameTask>.from(taskQueue);
    switch (pos) {
      case GameStateTaskPushPos.head:
        nextQueue.addFirst(task);
      case GameStateTaskPushPos.tail:
        nextQueue.add(task);
    }
    return copyWith(taskQueue: nextQueue);
  }

  GameState pushTasks(GameStateTaskPushPos pos, List<GameTask> tasks) {
    final nextQueue = QueueList<GameTask>.from(taskQueue);
    switch (pos) {
      case GameStateTaskPushPos.head:
        tasks.reversed.forEach(nextQueue.addFirst);
      case GameStateTaskPushPos.tail:
        nextQueue.addAll(tasks);
    }
    return copyWith(taskQueue: nextQueue);
  }

  GameState popTask() {
    if (taskQueue.isEmpty) return this;
    final nextQueue = QueueList<GameTask>.from(taskQueue)..removeFirst();
    return copyWith(taskQueue: nextQueue);
  }
}

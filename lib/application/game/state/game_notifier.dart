import 'dart:async';

import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/game/state/seed_generator.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/application/remote_sync/in_game/state/game_actions_watch_provider.dart';
import 'package:dereruministic/application/remote_sync/in_game/usecases/append_game_actions_usecase.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  RoomId? _roomId;

  @override
  GameState? build() {
    return null;
  }

  GameFlowUsecase get _flow => ref.read(gameFlowUsecaseProvider);

  Future<void> _dispatch({
    required GameActions action,
    GameState? base,
  }) async {
    final roomId = _roomId;
    if (roomId == null) return;

    final current = base ?? state;
    final result = _flow.applyAction(current: current, action: action);
    _applyResult(result);

    if (result is ApplyActionResultSuccess) {
      unawaited(
        ref
            .read(appendGameActionsUsecaseProvider)
            .execute(roomId: roomId, action: action),
      );
    }
  }

  void _initRoom(RoomId roomId) {
    if (_roomId != null) return;
    _roomId = roomId;

    ref.listen(gameActionsAddedWatchProvider(roomId: roomId), (prev, next) {
      next.whenData(applyRemoteAction);
    });
  }

  void _applyResult(ApplyActionResult result) {
    switch (result) {
      case ApplyActionResultSuccess(:final state, :final steps):
        this.state = state;
        ref.read(stepEventQueueProvider.notifier).enqueueAll(steps);
      case ApplyActionResultFailure():
      //TODO(error): ERRORハンドリング
    }
  }

  Future<void> startGame(RoomId roomId, Player playerA, Player playerB) async {
    if (state != null) return;
    _initRoom(roomId);

    final generateSeed = ref.read(seedGeneratorProvider);
    final seed = generateSeed();

    final action = GameActions.gameStart(
      id: GameActionsId.generate(),
      actionSequenceNumber: 1,
      playerId: playerA.id,
      playerBId: playerB.id,
      playerADeckRecipe: playerA.deckRecipe,
      playerBDeckRecipe: playerB.deckRecipe,
      seed: seed,
    );

    await _dispatch(
      action: action,
    );
  }

  void joinGame(RoomId roomId) {
    _initRoom(roomId);
  }

  Future<void> playCard(GameCard card, PlayerId cardUsedPlayerId) async {
    final currentState = state;
    if (currentState == null) return;

    final action = GameActions.playCard(
      id: GameActionsId.generate(),
      actionSequenceNumber: currentState.metadata.actionSequenceNumber + 1,
      playerId: cardUsedPlayerId,
      cardInstanceId: card.instanceId,
    );

    await _dispatch(action: action);
  }

  Future<void> endTurn() async {
    final currentState = state;
    if (currentState == null) return;
    if (currentState.phase.battlePhase == BattlePhase.battleEnd) return;
    final action = GameActions.turnEnd(
      id: GameActionsId.generate(),
      actionSequenceNumber: currentState.metadata.actionSequenceNumber + 1,
      playerId: currentState.phase.turnOwner,
    );

    await _dispatch(action: action);
  }

  void applyRemoteAction(GameActions action) {
    final currentState = state;
    final playerId = ref.read(currentUserProfileProvider.select((s) => s.id));
    if (action.playerId == playerId) return;

    final result = _flow.applyAction(current: currentState, action: action);
    _applyResult(result);
  }

  void surrender() {
    final currentState = state;
    if (currentState == null) return;
  }
}

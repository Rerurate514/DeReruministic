import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_card_states_service.g.dart';

@riverpod
ResolveCardStatesService resolveCardStatesService(Ref ref) {
  return const ResolveCardStatesService();
}

class ResolveCardStatesService {
  const ResolveCardStatesService();

  ApplyActionResult process({
    required GameState state,
    required PlayerId playerId,
    required GameCardInstanceId cardInstanceId,
    required CardStates cardState,
  }) {
    final player = state.players[playerId];
    if (player == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    return switch (cardState) {
      CardStateOverload(:final amount) => _applyOverload(state, player, amount),
      CardStateExhaust() => _applyExhaust(state, playerId, cardInstanceId),
      CardStateRecycle() => _applyRecycle(state, playerId, cardInstanceId),
      CardStateInfect() => throw UnimplementedError(),
      CardStateCountdown(:final turns) => throw UnimplementedError(),
      CardStateDecay(:final turns) => throw UnimplementedError(),
      CardStateUndiscardable() => throw UnimplementedError(),
      CardStateConceal() => throw UnimplementedError(),
      CardStateRetain() => throw UnimplementedError(),
      CardStateEngrave() => throw UnimplementedError(),
      CardStateChain() => throw UnimplementedError(),
    };
  }

  ApplyActionResult _applyOverload(
    GameState state,
    PlayerState player,
    int amount,
  ) {
    final updatedPlayer = player.copyWith(
      pendingOverloadCost: player.pendingOverloadCost + amount,
    );
    final newState = state.copyWith(
      players: {...state.players, player.id: updatedPlayer},
    );
    return ApplyActionResult.success(state: newState, steps: []);
  }

  ApplyActionResult _applyExhaust(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final newState = state.moveCardFromPlayArea(
      playerId: playerId,
      cardInstanceId: instanceId,
      to: CardZone.exhausted,
    );

    final step = GameStepEvent.cardMovedZone(
      playerId: playerId,
      cardInstanceIds: [instanceId],
      zoneFrom: CardZone.playArea,
      zoneTo: CardZone.exhausted,
    );
    return ApplyActionResult.success(state: newState, steps: [step]);
  }

  ApplyActionResult _applyRecycle(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final decrementedState = state.decrementRecycleCount(
      playerId: playerId,
      cardInstanceId: instanceId,
    );

    final updatedCard = decrementedState.findGameCard(
      playerId: playerId,
      cardInstanceId: instanceId,
    );

    final destinationZone = updatedCard?.isRecycleActive ?? false
        ? CardZone.deck
        : CardZone.graveyard;

    final newState = decrementedState.moveCardFromPlayArea(
      playerId: playerId,
      cardInstanceId: instanceId,
      to: destinationZone,
    );

    final step = GameStepEvent.cardMovedZone(
      playerId: playerId,
      cardInstanceIds: [instanceId],
      zoneFrom: CardZone.playArea,
      zoneTo: destinationZone,
    );
    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

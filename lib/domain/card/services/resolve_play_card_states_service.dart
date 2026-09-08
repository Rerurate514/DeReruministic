import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_states_trigger_type.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_play_card_states_service.g.dart';

@riverpod
ResolvePlayCardStatesService resolvePlayCardStatesService(Ref ref) {
  return const ResolvePlayCardStatesService();
}

class ResolvePlayCardStatesService {
  const ResolvePlayCardStatesService();

  ApplyActionResult execute({
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
      CardStateExhaust() => _applyExhaust(state, playerId, cardInstanceId),
      CardStateOverload(:final amount) => _applyOverload(
        state,
        player,
        amount,
      ),
      CardStateRecycle() => _applyRecycle(state, playerId, cardInstanceId),
      CardStateConceal() => throw UnimplementedError(),
      CardStateRetain() => throw UnimplementedError(),
      CardStateEngrave() => throw UnimplementedError(),
      CardStateChain() => throw UnimplementedError(),
      CardStateInfect() => throw UnimplementedError(),
      _ => ApplyActionResult.noSteps(state: state),
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
    final newState = state.moveCardZone(
      playerId: playerId,
      cardInstanceId: instanceId,
      from: CardZone.playArea,
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

    final isRecycleActive = updatedCard?.isRecycleActive ?? false;

    if (isRecycleActive) {
      final newState = decrementedState.moveCardZone(
        playerId: playerId,
        cardInstanceId: instanceId,
        from: CardZone.playArea,
        to: CardZone.deck,
      );

      final step = GameStepEvent.cardMovedZone(
        playerId: playerId,
        cardInstanceIds: [instanceId],
        zoneFrom: CardZone.playArea,
        zoneTo: CardZone.deck,
      );

      return ApplyActionResult.success(state: newState, steps: [step]);
    } else {
      final recycleRuntime = updatedCard?.recycleRuntime;
      if (recycleRuntime == null) {
        return ApplyActionResult.failure(
          state: state,
          reason: ActionFailureReason.cardNotFound,
        );
      }

      final newState = decrementedState.pushTask(
        GameStateTaskPushPos.head,
        .auto(
          .resolveCardStatesTrigger(
            playerId: playerId,
            cardInstanceId: instanceId,
            triggerType: CardStatesTriggerType.recycleExpired,
          ),
        ),
      );

      return ApplyActionResult.success(state: newState, steps: []);
    }
  }
}

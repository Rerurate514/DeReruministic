import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
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
      CardStateExhaust() => _applyCleanup(state, playerId, cardInstanceId),
      CardStateOverload(:final amount) => _applyCleanup(
        _applyOverload(
          state,
          player,
          amount,
        ),
        playerId,
        cardInstanceId,
      ),
      CardStateRecycle() => _applyCleanup(
        _applyRecycle(state, playerId, cardInstanceId),
        playerId,
        cardInstanceId,
      ),
      CardStateConceal() => throw UnimplementedError(),
      CardStateRetain() => throw UnimplementedError(),
      CardStateEngrave() => throw UnimplementedError(),
      CardStateChain() => throw UnimplementedError(),
      CardStateInfect() => throw UnimplementedError(),
      _ => _applyCleanup(
        state,
        playerId,
        cardInstanceId,
      ),
    };
  }

  ApplyActionResult _applyCleanup(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final newState = state.pushTask(
      GameStateTaskPushPos.head,
      .auto(
        .cleanupPlayCard(
          playerId: playerId,
          cardInstanceId: instanceId,
        ),
      ),
    );
    return ApplyActionResult.success(state: newState, steps: []);
  }

  GameState _applyOverload(
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
    return newState;
  }

  GameState _applyRecycle(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) => state.decrementRecycleCount(
    playerId: playerId,
    cardInstanceId: instanceId,
  );
}

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
    required GameCardInstanceId instanceId,
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
      CardStateOverload(:final amount) => _applyOverload(
        state,
        player,
        amount,
      ),
      CardStateRecycle() => _applyRecycle(state, playerId, instanceId),
      CardStateConceal() => _buildNoStep(state), //TODO(medium): このあたり実装する
      CardStateRetain() => _buildNoStep(state),
      CardStateEngrave() => _buildNoStep(state),
      CardStateChain() => _buildNoStep(state),
      CardStateInfect() => _buildNoStep(state),
      _ => _buildNoStep(state),
    };
  }

  ApplyActionResult _buildNoStep(GameState state) =>
      ApplyActionResult.noSteps(state: state);

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

  ApplyActionResult _applyRecycle(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final newState = state.decrementRecycleCount(
      playerId: playerId,
      instanceId: instanceId,
    );

    return ApplyActionResult.success(state: newState, steps: []);
  }
}

import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_end_phase_card_states_service.g.dart';

@riverpod
ResolveEndPhaseCardStatesService resolveEndPhaseCardStatesService(Ref ref) {
  return const ResolveEndPhaseCardStatesService();
}

class ResolveEndPhaseCardStatesService {
  const ResolveEndPhaseCardStatesService();

  ApplyActionResult execute({
    required GameState state,
  }) {
    final targetPlayer = state.currentTurnOwner;
    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newState = state.advanceHandCardRuntimeStates(
      playerId: targetPlayer.id,
    );

    final step = GameStepEvent.handCardCountersUpdated(
      playerId: targetPlayer.id,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

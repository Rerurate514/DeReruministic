import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'advanced_to_main_phase_service.g.dart';

@riverpod
AdvanceToMainPhaseService advanceToMainPhaseService(Ref ref) {
  return const AdvanceToMainPhaseService();
}

class AdvanceToMainPhaseService implements TurnProcessStep {
  const AdvanceToMainPhaseService();

  @override
  ApplyActionResult execute(GameState state) {
    final updatedPhase = state.phase.copyWith(
      battlePhase: BattlePhase.mainPhase,
    );

    final newState = state.copyWith(
      phase: updatedPhase,
    );

    final step = GameStepEvent.phaseChanged(
      phase: updatedPhase,
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [step],
    );
  }
}

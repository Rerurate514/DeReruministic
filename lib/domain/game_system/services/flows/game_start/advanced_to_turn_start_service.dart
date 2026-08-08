import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'advanced_to_turn_start_service.g.dart';

@riverpod
AdvancedToTurnStartService advancedToTurnStartService(Ref ref) {
  return const AdvancedToTurnStartService();
}

class AdvancedToTurnStartService implements TurnProcessStep {
  const AdvancedToTurnStartService();

  @override
  ApplyActionResult execute(GameState state) {
    final updatedPhase = state.phase.copyWith(
      battlePhase: BattlePhase.turnStart,
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

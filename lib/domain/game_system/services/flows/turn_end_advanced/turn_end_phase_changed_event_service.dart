import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'turn_end_phase_changed_event_service.g.dart';

@riverpod
TurnEndPhaseChangedEventService turnEndPhaseChangedEventService(Ref ref) {
  return TurnEndPhaseChangedEventService();
}

class TurnEndPhaseChangedEventService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final newState = state.copyWith(
      phase: state.phase.copyWith(battlePhase: .turnEnd),
    );

    final phaseEvent = GameStepEvent.phaseChanged(phase: newState.phase);

    return ApplyActionResult.success(
      state: newState,
      steps: [phaseEvent],
    );
  }
}

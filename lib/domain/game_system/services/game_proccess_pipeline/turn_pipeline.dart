import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';

class TurnPipeline {
  const TurnPipeline({
    required this.turnProcessSteps,
  });

  final List<TurnProcessStep> turnProcessSteps;

  ApplyActionResult process(
    GameState state,
    List<GameStepEvent> initialSteps,
  ) {
    final accumulatedSteps = <GameStepEvent>[];
    var currentState = state;

    for (final turnProcessStep in turnProcessSteps) {
      final result = turnProcessStep.execute(currentState);

      if (result case ApplyActionResultFailure()) {
        return result;
      }

      accumulatedSteps.addAll((result as ApplyActionResultSuccess).steps);
      currentState = result.state;

      if (currentState.phase.battlePhase.isFinished ||
          currentState.phase.battlePhase.requiresPlayerInput) {
        break;
      }
    }

    return ApplyActionResult.success(
      state: currentState,
      steps: [...initialSteps, ...accumulatedSteps],
    );
  }
}

import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';

class TurnPipeline {
  const TurnPipeline({
    required this.turnProcessSteps,
  });

  final List<TurnProcessStep> turnProcessSteps;

  ApplyActionResult process(
    GameState current,
    List<GameStepEvent> initialSteps,
  ) {
    final accumulatedSteps = <GameStepEvent>[];
    var currentState = current;

    for (final turnProcessStep in turnProcessSteps) {
      final result = turnProcessStep.execute(currentState);
      accumulatedSteps.addAll(result.steps);
      currentState = result.state;

      if (currentState.phase.battlePhase == BattlePhase.battleEnd) {
        break;
      }
    }

    return ApplyActionResult(state: currentState, steps: accumulatedSteps);
  }
}

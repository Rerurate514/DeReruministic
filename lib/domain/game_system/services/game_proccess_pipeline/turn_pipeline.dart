import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'turn_pipeline.g.dart';

@riverpod
TurnPipeline turnPipeline(Ref ref) {
  return TurnPipeline();
}

class TurnPipeline {
  ApplyActionResult process(
    GameState current,
    List<GameStepEvent> initialSteps,
    List<TurnProcessStep> turnProcessSteps,
  ) {
    final accumulatedSteps = <GameStepEvent>[];
    var currentState = current;

    for (final turnProcessStep in turnProcessSteps) {
      final result = turnProcessStep.execute(currentState);
      accumulatedSteps.addAll(result.steps);
      currentState = result.state;
    }

    return ApplyActionResult(state: currentState, steps: accumulatedSteps);
  }
}

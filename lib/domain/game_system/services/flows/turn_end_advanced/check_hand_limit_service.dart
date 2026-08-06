import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_hand_limit_service.g.dart';

@riverpod
CheckHandLimitService checkHandLimitService(Ref ref) {
  return CheckHandLimitService();
}

class CheckHandLimitService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final player = state.currentTurnOwner;

    final overflowCount = player.hand.length - player.maxHandSize;

    if (overflowCount <= 0) {
      return ApplyActionResult.noSteps(state: state);
    }

    final newState = state.copyWith(
      phase: state.phase.copyWith(battlePhase: .selectDiscard),
    );

    final step = GameStepEvent.overflowCheckTriggered(
      playerId: player.id,
      overflowCount: overflowCount.abs(),
    );

    return ApplyActionResult(state: newState, steps: [step]);
  }
}

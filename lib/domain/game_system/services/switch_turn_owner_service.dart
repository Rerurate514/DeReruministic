import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'switch_turn_owner_service.g.dart';

@riverpod
SwitchTurnOwnerService switchTurnOwnerService(Ref ref) {
  return SwitchTurnOwnerService();
}

class SwitchTurnOwnerService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState current) {
    const event = GameStepEventTransition(type: GameStepType.phaseChanged);

    return ApplyActionResult(state: current.nextTurn(), steps: [event]);
  }
}

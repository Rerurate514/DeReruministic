import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'switch_turn_owner_service.g.dart';

@riverpod
SwitchTurnOwnerService switchTurnOwnerService(Ref ref) {
  return SwitchTurnOwnerService();
}

class SwitchTurnOwnerService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final newState = state.nextTurn();
    final switchEvent = GameStepEvent.turnOwnerSwitched(
      newTurnPlayerId: newState.phase.turnOwner,
    );

    final phaseEvent = GameStepEvent.phaseChanged(phase: newState.phase);

    return ApplyActionResult.success(
      state: newState,
      steps: [switchEvent, phaseEvent],
    );
  }
}

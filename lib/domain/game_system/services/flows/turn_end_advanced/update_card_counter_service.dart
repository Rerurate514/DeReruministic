import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_card_counter_service.g.dart';

@riverpod
UpdateCardCounterService updateCardCounterService(Ref ref) {
  return UpdateCardCounterService();
}

class UpdateCardCounterService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final targetPlayer = state.currentTurnOwner;
    final newState = state.advanceHandCardRuntimeStates(
      playerId: targetPlayer.id,
    );

    final step = GameStepEvent.handCardCountersUpdated(
      playerId: targetPlayer.id,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

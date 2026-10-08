import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_combo_service.g.dart';

@riverpod
ResetComboService resetComboService(Ref ref) => ResetComboService();

class ResetComboService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final targetPlayer = state.currentTurnOwner;
    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }
    final updatedPlayer = targetPlayer.removeBuff(BuffTypes.combo);

    return ApplyActionResult.success(
      state: state.copyWith(
        players: {...state.players, updatedPlayer.id: updatedPlayer},
      ),
      steps: [GameStepEvent.comboReset(phase: state.phase)],
    );
  }
}

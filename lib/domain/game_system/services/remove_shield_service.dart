import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remove_shield_service.g.dart';

@riverpod
RemoveShieldService removeShieldService(Ref ref) {
  return RemoveShieldService();
}

class RemoveShieldService {
  ApplyActionResult execute({
    required GameState current,
  }) {
    final targetPlayerId = current.shieldClearTargetId;

    final event = GameStepEvent.valueChanged(
      type: GameStepType.shieldCleared,
      targetPlayerId: targetPlayerId,
      amount: 0,
    );

    return ApplyActionResult(
      state: current.clearShield(targetPlayerId),
      steps: [event],
    );
  }
}

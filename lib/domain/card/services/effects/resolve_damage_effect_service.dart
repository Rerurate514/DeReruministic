import 'package:dereruministic/domain/card/services/calculators/damage_calculator.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/auto_game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/damage_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_damage_effect_service.g.dart';

@riverpod
ResolveDamageEffectService resolveDamageEffectService(Ref ref) {
  return ResolveDamageEffectService();
}

class ResolveDamageEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectDamage effect,
    required PlayerId sourcePlayerId,
  }) {
    final sourcePlayer = state.players[sourcePlayerId];

    if (sourcePlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final targetPlayer = effect.target.getTargetPlayer(
      state,
      sourcePlayerId,
    );

    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final finalDamage = DamageCalculator.execute(
      baseDamage: effect.amount,
      attacker: sourcePlayer,
      defender: targetPlayer,
    );

    final task = GameTask.auto(
      AutoGameTask.applyDamage(
        targetPlayerId: targetPlayer.id,
        damage: finalDamage,
        type: DamageTypes.normal,
        sourcePlayerId: sourcePlayerId,
      ),
    );

    final newState = state.popTask().pushTask(
      GameStateTaskPushPos.head,
      task,
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [],
    );
  }
}

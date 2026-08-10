import 'dart:math';

import 'package:dereruministic/domain/card/services/calculators/damage_calculator.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
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
    final sourcePlayer = state.players[sourcePlayerId]!;

    final targetPlayer = effect.target.getTargetPlayer(state, sourcePlayerId);

    final finalDamage = DamageCalculator.execute(
      baseDamage: effect.amount,
      attacker: sourcePlayer,
      defender: targetPlayer,
    );

    final shieldDamage = min(targetPlayer.shield, finalDamage);
    final hpDamage = finalDamage - shieldDamage;
    final finalHp = targetPlayer.hp - hpDamage;

    final newCardTargetPlayer = targetPlayer.copyWith(
      shield: targetPlayer.shield - shieldDamage,
      hp: finalHp.clamp(0, targetPlayer.maxHp),
    );

    final newState = state.copyWith(
      players: {...state.players, newCardTargetPlayer.id: newCardTargetPlayer},
    );

    final step = GameStepEvent.damageDealt(
      targetPlayerId: newCardTargetPlayer.id,
      shieldDamage: shieldDamage,
      hpDamage: hpDamage,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

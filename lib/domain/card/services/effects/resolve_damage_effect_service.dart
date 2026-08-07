import 'dart:math';

import 'package:dereruministic/domain/card/services/calculators/damage_calculator.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

class ResolveDamageEffectService {
  ApplyActionResult execute(
    GameState state,
    CardEffectDamage effect,
    PlayerId sourcePlayerId,
    PlayerId? targetPlayerId,
  ) {
    final sourcePlayer = state.players[sourcePlayerId]!;

    final targetPlayer = targetPlayerId != null
        ? state.players[targetPlayerId]!
        : switch (effect.target) {
            CardTargetTypes.self => sourcePlayer,
            CardTargetTypes.enemy => state.players.values.firstWhere(
              (p) => p.id != sourcePlayerId,
            ),
          };

    final finalDamage = DamageCalculator.execute(
      baseDamage: effect.amount,
      attacker: sourcePlayer,
      defender: targetPlayer,
    );

    final shieldDamage = min(targetPlayer.shield, finalDamage);
    final hpDamage = finalDamage - shieldDamage;

    final newCardTargetPlayer = targetPlayer.copyWith(
      shield: targetPlayer.shield - shieldDamage,
      hp: targetPlayer.hp - hpDamage,
    );

    final newState = state.copyWith(
      players: {...state.players, newCardTargetPlayer.id: newCardTargetPlayer},
    );

    final step = GameStepEvent.damageDealt(
      targetPlayerId: newCardTargetPlayer.id,
      shieldDamage: shieldDamage,
      hpDamage: hpDamage,
    );

    return ApplyActionResult(state: newState, steps: [step]);
  }
}

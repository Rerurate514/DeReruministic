import 'dart:math';

import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';

class DamageCalculator {
  static int execute({
    required int baseDamage,
    required PlayerState attacker,
    required PlayerState defender,
  }) {
    final modifiers = <int Function(int)>[
      ...attacker.buffs
          .where((b) => b.buff.isOutgoingDamageModifier)
          .map(
            (b) =>
                (damage) => b.modifyOutgoingDamage(damage),
          ),
      ...attacker.debuffs
          .where((d) => d.debuff.isOutgoingDamageModifier)
          .map(
            (d) =>
                (damage) => d.modifyOutgoingDamage(damage),
          ),
      ...defender.buffs
          .where((b) => b.buff.isIncomingDamageModifier)
          .map(
            (b) =>
                (damage) => b.modifyIncomingDamage(damage),
          ),
      ...defender.debuffs
          .where((d) => d.debuff.isIncomingDamageModifier)
          .map(
            (d) =>
                (damage) => d.modifyIncomingDamage(damage),
          ),
    ];

    final calculatedDamage = modifiers.fold(
      baseDamage,
      (currentDamage, modify) => modify(currentDamage),
    );

    return max(0, calculatedDamage);
  }
}

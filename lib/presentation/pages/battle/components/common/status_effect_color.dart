import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

extension BuffTypesStatusEffectColorEx on BuffTypes {
  Color color(AppColorScheme theme) {
    return switch (this) {
      .atkBuff => theme.buffAttack,
      .regeneration => theme.buffRegeneration,
      .costRecovery => theme.buffCostRecovery,
      .guardBoost => theme.buffGuardBoost,
      .reflect => theme.buffReflect,
      .combo => theme.buffCombo,
      .drawBoost => theme.buffDrawBoost,
    };
  }
}

extension DebuffTypesStatusEffectColorEx on DebuffTypes {
  Color color(AppColorScheme theme) {
    return switch (this) {
      .atkDebuff => theme.debuffAttack,
      .poison => theme.debuffPoison,
      .vulnerable => theme.debuffVulnerable,
      .costReduction => theme.debuffCostReduction,
      .drawReduction => theme.debuffDrawReduction,
    };
  }
}

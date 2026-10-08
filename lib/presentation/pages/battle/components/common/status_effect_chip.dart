import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/status_effect_color.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class StatusEffectChip extends StatelessWidget {
  StatusEffectChip.buff({required BuffState state, super.key})
    : label = state.buff.label,
      stack = state.stack,
      icon = state.buff.icon,
      colorResolver = state.buff.color;

  StatusEffectChip.debuff({required DebuffState state, super.key})
    : label = state.debuff.label,
      stack = state.stack,
      icon = state.debuff.icon,
      colorResolver = state.debuff.color;

  final String label;
  final int stack;
  final IconData icon;
  final Color Function(AppColorScheme theme) colorResolver;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final color = colorResolver(theme);

    return Tooltip(
      message: '$label ×$stack',
      child: Semantics(
        label: '$label $stack',
        child: AppCard(
          isBlur: true,
          borderRadius: 4,
          borderWidth: 1,
          borderColor: color.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                '×$stack',
                style: GoogleFonts.shareTechMono(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on BuffTypes {
  String get label {
    return switch (this) {
      .atkBuff => 'ATK UP',
      .regeneration => 'REGEN',
      .costRecovery => 'COST UP',
      .guardBoost => 'GUARD',
      .reflect => 'REFLECT',
      .combo => 'COMBO',
      .drawBoost => 'DRAW UP',
    };
  }

  IconData get icon {
    return switch (this) {
      .atkBuff => Symbols.swords,
      .regeneration => Symbols.heart_plus,
      .costRecovery => Symbols.bolt,
      .guardBoost => Symbols.shield,
      .reflect => Symbols.autorenew,
      .combo => Symbols.link_2,
      .drawBoost => Symbols.playing_cards,
    };
  }
}

extension on DebuffTypes {
  String get label {
    return switch (this) {
      .atkDebuff => 'ATK DOWN',
      .poison => 'POISON',
      .vulnerable => 'VULNERABLE',
      .costReduction => 'COST DOWN',
      .drawReduction => 'DRAW DOWN',
    };
  }

  IconData get icon {
    return switch (this) {
      .atkDebuff => Symbols.swords,
      .poison => Symbols.skull,
      .vulnerable => Symbols.heart_broken,
      .costReduction => Symbols.bolt,
      .drawReduction => Symbols.playing_cards,
    };
  }
}

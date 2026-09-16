import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_hp_base.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_shield_base.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShieldSystemDescription extends StatelessWidget {
  const ShieldSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: l10n.battle_page_shield_system_title,
      titleColor: theme.shield,
      leading: const Icon(Symbols.shield),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(l10n.battle_page_shield_system_detail_1),

          Wrap(
            crossAxisAlignment: .center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 2, right: 4),
                child: SizedBox(
                  height: 32,
                  child: StateShieldBase(
                    shield: 10,
                  ),
                ),
              ),

              Text(l10n.battle_page_shield_system_detail_2),

              const Icon(Symbols.arrow_right_alt),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: SizedBox(
                  width: 120,
                  child: StateHpBase(
                    hp: 90,
                    maxHp: 100,
                    isPlayer: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

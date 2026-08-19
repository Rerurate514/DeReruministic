import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_hp_base.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HpSystemDescription extends StatelessWidget {
  const HpSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: l10n.battle_page_hp_system_title,
      titleColor: theme.playerHp,
      leading: const Icon(Symbols.heart_plus),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(l10n.battle_page_hp_system_details_1),

          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 8, right: 4),
            child: SizedBox(
              width: double.infinity,
              child: StateHpBase(
                hp: 75,
                maxHp: 100,
                isPlayer: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

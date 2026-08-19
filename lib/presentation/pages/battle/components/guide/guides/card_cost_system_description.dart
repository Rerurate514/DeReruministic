import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_card_cost.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_cost.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardCostSystemDescription extends StatelessWidget {
  const CardCostSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: l10n.battle_page_card_cost_system_title,
      titleColor: theme.costDp,
      leading: const Icon(Symbols.bolt_boost),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(l10n.battle_page_card_cost_system_details_1),

          Wrap(
            crossAxisAlignment: .center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 2, right: 4),
                child: SizedBox(
                  width: 50,
                  child: StateCardCost(
                    cost: 2,
                  ),
                ),
              ),
              Text(l10n.battle_page_card_cost_system_details_2),
              const Padding(
                padding: EdgeInsets.only(left: 2, right: 4),
                child: SizedBox(
                  width: 116,
                  child: StateCost(
                    cost: 1,
                    maxCost: 4,
                  ),
                ),
              ),
              Text(l10n.battle_page_card_cost_system_details_3),
            ],
          ),
        ],
      ),
    );
  }
}

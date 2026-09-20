import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states_base.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class OverflowCardDiscardSystemDescription extends StatelessWidget {
  const OverflowCardDiscardSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: l10n.battle_page_overflow_discard_card_system_title,
      titleColor: theme.brandTertiary,
      leading: const Row(
        mainAxisAlignment: .center,
        spacing: 4,
        children: [
          Icon(Symbols.delete),
          Icon(Symbols.playing_cards),
        ],
      ),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(
            l10n.battle_page_overflow_discard_card_system_detail_1(
              PlayerConstants.defaultMaxHandSize,
            ),
          ),
          Text(l10n.battle_page_overflow_discard_card_system_detail_2),
          const CardStatesBase(
            states: .undiscardable(),
          ),
        ],
      ),
    );
  }
}

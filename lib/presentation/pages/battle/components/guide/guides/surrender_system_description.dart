import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/turn/game_phase_chip.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SurrenderSystemDescription extends StatelessWidget {
  const SurrenderSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: l10n.battle_page_surrender_system_title,
      titleColor: theme.shield,
      leading: const Icon(Symbols.location_disabled),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(l10n.battle_page_surrender_system_detail_1),

          Wrap(
            spacing: 16,
            crossAxisAlignment: .center,
            children: [
              const GamePhaseChip(),
              Text(l10n.battle_page_surrender_system_detail_2),
            ],
          ),
        ],
      ),
    );
  }
}

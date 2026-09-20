import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/state/card_state_list.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class ConcealCardMeta extends StatelessWidget {
  const ConcealCardMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Column(
      crossAxisAlignment: .end,
      children: [
        AppCard(
          background: theme.surfaceContainer.withAlpha(200),
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(
                Symbols.bolt,
                size: 16,
                color: theme.brandSecondary,
              ),
              Text(
                l10n.battle_page_conceal_card_cost,
                style: GoogleFonts.shareTechMono(
                  fontSize: 16,
                  color: theme.brandSecondary,
                ),
              ),
            ],
          ),
        ),
        const CardStateList(states: [.conceal()], runtimeStates: []),
      ],
    );
  }
}

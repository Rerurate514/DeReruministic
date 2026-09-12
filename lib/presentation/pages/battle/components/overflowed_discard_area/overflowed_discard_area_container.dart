import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflow_count_text.dart';
import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflowed_discard_area.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class OverflowedDiscardAreaContainer extends StatelessWidget {
  const OverflowedDiscardAreaContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppCard(
      padding: const EdgeInsets.all(8),
      isBlur: true,
      blurSigma: 10,
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(
                Symbols.terminal,
                size: 18,
                color: theme.textPrimary.withAlpha(100),
              ),
              Text(
                l10n.battle_page_discard_overflowed_card,
                style: GoogleFonts.shareTechMono(
                  letterSpacing: 2,
                  color: theme.textPrimary.withAlpha(100),
                ),
              ),
            ],
          ),
          const Divider(),
          const OverflowCountText(),
          const Expanded(
            child: OverflowedDiscardArea(),
          ),
        ],
      ),
    );
  }
}

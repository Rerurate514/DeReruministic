import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/event_log/event_log_content.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class EventLogComponent extends StatelessWidget {
  const EventLogComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return SizedBox.expand(
      child: AppCard(
        padding: const EdgeInsets.all(8),
        isBlur: true,
        blurSigma: 10,
        child: Column(
          spacing: 16,
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
                  l10n.battle_page_combat_log_text,
                  style: GoogleFonts.shareTechMono(
                    letterSpacing: 2,
                    color: theme.textPrimary.withAlpha(100),
                  ),
                ),
              ],
            ),
            const Divider(),
            const Expanded(
              child: EventLogContent(),
            ),
          ],
        ),
      ),
    );
  }
}

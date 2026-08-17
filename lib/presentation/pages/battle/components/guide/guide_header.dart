import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class GuideHeader extends StatelessWidget {
  const GuideHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return Row(
      spacing: 8,
      children: [
        Icon(
          Symbols.terminal,
          color: theme.brandColor,
        ),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.battle_page_guide_header_command,
              style: GoogleFonts.shareTechMono(
                color: theme.brandColor,
                fontSize: 20,
              ),
            ),
            Text(
              l10n.battle_page_guide_header_text,
              style: GoogleFonts.shareTechMono(
                color: theme.brandColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

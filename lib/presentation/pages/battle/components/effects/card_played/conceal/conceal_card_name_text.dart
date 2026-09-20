import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/painter/under_card_name_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConcealCardNameText extends StatelessWidget {
  const ConcealCardNameText({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Stack(
      children: [
        Text(
          l10n.battle_page_conceal_card_text,
          style: GoogleFonts.shareTechMono(
            color: theme.brandColor,
            shadows: [
              Shadow(
                color: theme.brandColor,
                blurRadius: 1,
              ),
            ],
            letterSpacing: 1,
          ),
        ),
        CustomPaint(
          painter: UnderCardNamePainter(color: theme.brandSecondary),
        ),
      ],
    );
  }
}

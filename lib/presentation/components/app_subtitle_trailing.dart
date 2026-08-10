import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSubtitleTrailing extends StatelessWidget {
  const AppSubtitleTrailing({
    super.key,
    this.fontSize = 12.0,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Text(
      l10n.app_subtitle_trailing,
      style: GoogleFonts.shareTechMono(
        fontSize: fontSize,
        color: theme.brandSecondary,
        letterSpacing: 2,
      ),
    );
  }
}

import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_vertical_move_child.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class BackgroundTextLines extends HookWidget {
  const BackgroundTextLines({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        AppVerticalMoveChild(
          begin: const Offset(0, -2),
          end: const Offset(0, 2),
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              l10n.battle_page_background_text_lines_left,
              style: GoogleFonts.shareTechMono(
                color: theme.brandSecondary.withAlpha(50),
              ),
            ),
          ),
        ),
        AppVerticalMoveChild(
          begin: const Offset(0, -2),
          end: const Offset(0, 2),
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              l10n.battle_page_background_text_lines_right,
              style: GoogleFonts.shareTechMono(
                color: theme.brandSecondary.withAlpha(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

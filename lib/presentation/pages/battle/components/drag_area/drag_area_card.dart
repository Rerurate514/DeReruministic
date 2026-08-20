import 'package:animated_text_effects/animated_text_effects.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/components/app_scan_line.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class DragAreaCard extends StatelessWidget {
  const DragAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppHollowGlowCard(
      blurSigma: 2,
      borderRadius: 4,
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: .center,
        children: [
          Column(
            mainAxisAlignment: .center,
            spacing: 8,
            children: [
              const Icon(Symbols.radar),
              FittedBox(
                child: AnimatedText(
                  l10n.battle_page_card_drag_area_text,
                  effects: const [TypewriterErrorEffect()],
                  style: GoogleFonts.shareTechMono(
                    color: theme.brandSecondary,
                    shadows: [
                      Shadow(
                        color: theme.brandSecondary,
                        blurRadius: 0.2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const AppScanLine(
            duration: Duration(seconds: 6),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

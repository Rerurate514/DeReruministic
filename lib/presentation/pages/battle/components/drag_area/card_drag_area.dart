import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/components/app_scan_line.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardDragArea extends ConsumerWidget {
  const CardDragArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DragTarget<GameCard>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (detail) {
          print(detail.data);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isHovering ? Colors.cyanAccent : Colors.transparent,
                width: 2,
              ),
            ),
            child: AppHollowGlowCard(
              blurSigma: 2,
              borderRadius: 4,
              padding: const EdgeInsets.all(8),
              child: Stack(
                alignment: .center,
                children: [
                  FittedBox(
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 8,
                      children: [
                        const Icon(Symbols.radar),
                        Text(
                          l10n.battle_page_card_drag_area_text,
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
                      ],
                    ),
                  ),
                  const AppScanLine(
                    duration: Duration(seconds: 6),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

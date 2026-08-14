import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/components/app_scan_line.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardDragArea extends HookConsumerWidget {
  const CardDragArea({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final isMainPhase = useState(false);

    ref.listen(stepEventQueueProvider, (_, next) {
      if (next.isEmpty) return;

      final currentEvent = next.first;
      if (currentEvent is! GameStepEventPhaseChanged) return;
      if (currentEvent.phase.battlePhase != .mainPhase ||
          currentEvent.phase.turnOwner != player.id) {
        isMainPhase.value = false;
        return;
      }
      isMainPhase.value = true;
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DragTarget<GameCard>(
        onWillAcceptWithDetails: (_) {
          final turnOwner = ref.read(
            gameProvider.select((s) => s?.phase.turnOwner),
          );
          return turnOwner == player.id && isMainPhase.value;
        },
        onAcceptWithDetails: (detail) async {
          await ref
              .read(gameProvider.notifier)
              .playCard(detail.data, player.id);
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
                  Column(
                    mainAxisAlignment: .center,
                    spacing: 8,
                    children: [
                      const Icon(Symbols.radar),
                      FittedBox(
                        child: Text(
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
            ),
          );
        },
      ),
    );
  }
}

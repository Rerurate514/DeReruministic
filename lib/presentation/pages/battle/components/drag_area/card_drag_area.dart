import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/drag_area/drag_area_card.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardDragArea extends HookConsumerWidget {
  const CardDragArea({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final currentPhase = ref.watch(displayedPhaseProvider);
    final isMainPhase =
        currentPhase?.battlePhase == .mainPhase &&
        currentPhase?.turnOwner == player.id;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DragTarget<GameCard>(
        onWillAcceptWithDetails: (_) {
          final turnOwner = ref.read(
            gameProvider.select((s) => s?.phase.turnOwner),
          );
          return turnOwner == player.id && isMainPhase;
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
                color: isHovering ? theme.brandSecondary : Colors.transparent,
                width: 2,
              ),
            ),
            child: const DragAreaCard(),
          );
        },
      ),
    );
  }
}

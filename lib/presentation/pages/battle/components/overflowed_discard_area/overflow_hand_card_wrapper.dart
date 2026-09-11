import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_draggable.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverflowHandCardWrapper extends ConsumerWidget {
  const OverflowHandCardWrapper({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final isDraggable = !ref
        .watch(selectDiscardCardsProvider)
        .map((card) => card.instanceId)
        .contains(gameCard.instanceId);

    print(isDraggable);

    final path = Path()
      ..lineTo(180, 0)
      ..lineTo(180, 240)
      ..lineTo(0, 240)
      ..lineTo(0, 0)
      ..lineTo(180, 240)
      ..moveTo(0, 240)
      ..lineTo(180, 0);

    return Stack(
      children: [
        GameCardDraggable(
          gameCard: gameCard,
          isDraggable: isDraggable,
        ),
        if (isDraggable)
          const SizedBox.shrink()
        else
          CustomPaint(
            painter: GlowLinePainter(
              path: path,
              color: theme.brandTertiary,
            ),
          ),
      ],
    );
  }
}

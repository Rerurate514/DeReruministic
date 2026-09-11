import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflowed_card_draggable.dart';
import 'package:dereruministic/presentation/pages/battle/providers/is_dragging_in_deck_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/state/in_card_discard_area.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InDiscardCards extends ConsumerWidget {
  const InDiscardCards({required this.isHovering, super.key});

  final bool isHovering;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final gameCards = ref.watch(selectDiscardCardsProvider);

    return AppCard(
      borderColor: isHovering ? theme.brandSecondary : null,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverList.builder(
            itemCount: gameCards.length,
            itemBuilder: (context, index) {
              return OverflowedCardDraggable(
                gameCard: gameCards[index],
                createGameCard: (gameCard) =>
                    InCardDiscardArea(gameCard: gameCards[index], index: index),
                onDragStarted: () {
                  ref
                      .read(isDraggingInDiscardCardProvider.notifier)
                      .startDragging();
                },
                onDragEnd: (details) {
                  ref
                      .read(isDraggingInDiscardCardProvider.notifier)
                      .endDragging();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

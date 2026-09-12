import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflowed_card_draggable.dart';
import 'package:dereruministic/presentation/pages/battle/providers/is_dragging_in_deck_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/state/in_card_discard_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InDiscardCards extends ConsumerWidget {
  const InDiscardCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameCards = ref.watch(selectDiscardCardsProvider);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: gameCards.length,
      itemBuilder: (context, index) {
        return OverflowedCardDraggable(
          gameCard: gameCards[index],
          createGameCard: (gameCard) => InCardDiscardArea(
            gameCard: gameCards[index],
            index: index,
          ),
          onDragStarted: () {
            ref.read(isDraggingInDiscardCardProvider.notifier).startDragging();
          },
          onDragEnd: (details) {
            ref.read(isDraggingInDiscardCardProvider.notifier).endDragging();
          },
        );
      },
    );
  }
}

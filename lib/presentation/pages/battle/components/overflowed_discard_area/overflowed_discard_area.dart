import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/in_discard_cards.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_overflow_check_triggered_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/state/in_card_hand_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverflowedDiscardArea extends ConsumerWidget {
  const OverflowedDiscardArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overflowCount = ref.watch(displayedOverflowCheckTriggeredProvider);
    if (overflowCount == null) return const SizedBox.shrink();

    return DragTarget<InCardHandArea>(
      onWillAcceptWithDetails: (details) {
        return ref.read(selectDiscardCardsProvider).length < overflowCount;
      },
      onAcceptWithDetails: (details) {
        ref
            .read(selectDiscardCardsProvider.notifier)
            .add(details.data.gameCard);
      },
      builder:
          (
            context,
            candidateData,
            rejectedData,
          ) {
            final isHovering = candidateData.isNotEmpty;
            return InDiscardCards(
              isHovering: isHovering,
            );
          },
    );
  }
}

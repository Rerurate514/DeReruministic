import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/is_dragging_in_deck_notifier.dart';
import 'package:dereruministic/presentation/pages/deck_editor/state/in_card_place.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class InDeckCardRemoveArea extends ConsumerWidget {
  const InDeckCardRemoveArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final isDragging = ref.watch(isDraggingInDeckProvider);
    return DragTarget<InCardDeck>(
      onAcceptWithDetails: (details) {
        // final result = ref
        //     .read(draftDeckRecipeProvider.notifier)
        //     .addCard(details.data.defCard.cardDefId);

        print(details.data);
      },
      builder:
          (
            context,
            candidateData,
            rejectedData,
          ) {
            final isHovering = candidateData.isNotEmpty;

            if (!isDragging) return const SizedBox.shrink();

            return AppCard(
              isBlur: true,
              borderColor: isHovering ? theme.brandTertiary : null,
              child: const Column(
                mainAxisAlignment: .center,
                spacing: 8,
                children: [Icon(Symbols.delete), Text('このカードをデッキから削除する。')],
              ),
            );
          },
    );
  }
}

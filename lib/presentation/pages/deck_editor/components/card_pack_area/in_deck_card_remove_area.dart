import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/draft_deck_recipe_notifier.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/is_dragging_in_deck_notifier.dart';
import 'package:dereruministic/presentation/pages/deck_editor/state/in_card_place.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class InDeckCardRemoveArea extends ConsumerWidget {
  const InDeckCardRemoveArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final isDragging = ref.watch(isDraggingInDeckProvider);
    return DragTarget<InCardDeck>(
      onAcceptWithDetails: (details) {
        ref.read(draftDeckRecipeProvider.notifier).removeAt(details.data.index);
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
              borderRadius: 8,
              borderColor: isHovering ? theme.brandTertiary : null,
              child: Column(
                mainAxisAlignment: .center,
                spacing: 8,
                children: [
                  Icon(
                    Symbols.delete,
                    color: theme.brandTertiary,
                    size: 32,
                  ),
                  Text(
                    l10n.deck_editor_page_in_deck_card_remove_card_area_text,
                    style: GoogleFonts.shareTechMono(
                      color: theme.brandTertiary,
                      fontWeight: .bold,
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}

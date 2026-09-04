import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/my_deck_area/in_deck_cards.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/draft_deck_recipe_notifier.dart';
import 'package:dereruministic/presentation/pages/deck_editor/state/in_card_place.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class MyDeckArea extends ConsumerWidget {
  const MyDeckArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          spacing: 8,
          children: [
            const Icon(Symbols.view_carousel),
            Text(
              l10n.deck_editor_page_my_deck_header_title_text,
              style: GoogleFonts.shareTechMono(),
            ),
          ],
        ),
        Expanded(
          child: DragTarget<InCardPack>(
            onWillAcceptWithDetails: (details) {
              return !ref.read(draftDeckRecipeProvider).isDeckFull &&
                  !ref
                      .read(draftDeckRecipeProvider)
                      .isSameCardMax(details.data.defCard.cardDefId);
            },
            onAcceptWithDetails: (details) {
              ref
                  .read(draftDeckRecipeProvider.notifier)
                  .addCard(details.data.defCard.cardDefId);
            },
            builder:
                (
                  context,
                  candidateData,
                  rejectedData,
                ) {
                  final isHovering = candidateData.isNotEmpty;

                  return AppCard(
                    borderColor: isHovering ? theme.brandSecondary : null,
                    child: const CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [InDeckCards()],
                    ),
                  );
                },
          ),
        ),
      ],
    );
  }
}

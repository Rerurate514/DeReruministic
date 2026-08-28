import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_draggable.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/draft_deck_recipe_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InDeckCards extends ConsumerWidget {
  const InDeckCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogMap = ref.watch(cardCatalogMapProvider);
    final draftDeckDefIds = ref.watch(
      draftDeckRecipeProvider.select((s) => s.cardDefIds),
    );

    return SliverList.builder(
      itemCount: draftDeckDefIds.length,
      itemBuilder: (context, index) {
        return DefCardDraggable(
          defCard: catalogMap[draftDeckDefIds[index]]!,
        );
      },
    );
  }
}

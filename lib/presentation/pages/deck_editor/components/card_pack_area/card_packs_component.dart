import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card_packs/data/card_packs.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card_cross_paint.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_draggable.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card_pack_area/card_pack_section_header_delegate.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/draft_deck_recipe_notifier.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/selected_card_pack_type_notifier.dart';
import 'package:dereruministic/presentation/pages/deck_editor/state/in_card_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardPacksComponent extends ConsumerWidget {
  const CardPacksComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final catalogMap = ref.watch(cardCatalogMapProvider);
    final selectedPackType = ref.watch(selectedCardPackTypeProvider);
    final visiblePacks = switch (selectedPackType) {
      CardPackTypes.all =>
        CardPackTypes.values
            .where((packType) => packType != CardPackTypes.all)
            .map((packType) => cardPacksTypes[packType]!)
            .toList(),
      _ => [cardPacksTypes[selectedPackType]!],
    };

    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: visiblePacks.map((pack) {
        return SliverMainAxisGroup(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: CardPackSectionHeaderDelegate(title: pack.packName),
            ),
            SliverList.builder(
              itemCount: pack.cardDefIds.length,
              itemBuilder: (context, index) {
                final defCard = catalogMap[pack.cardDefIds[index]]!;
                return _MaxLimitCardOverlay(
                  label: l10n.deck_editor_page_in_deck_card_max_limit_label,

                  defCard: defCard,
                  child: DefCardDraggable<InCardPack>(
                    defCard: defCard,
                    createPlace: (defCard) =>
                        InCardPack(index: index, defCard: defCard),
                  ),
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _MaxLimitCardOverlay extends ConsumerWidget {
  const _MaxLimitCardOverlay({
    required this.label,
    required this.defCard,
    required this.child,
  });

  final String label;
  final CardDefinition defCard;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMaxLimit = ref.watch(
      draftDeckRecipeProvider.select((s) => s.isSameCardMax(defCard.cardDefId)),
    );

    return AppCardCrossPaint(label: label, isVisible: isMaxLimit, child: child);
  }
}

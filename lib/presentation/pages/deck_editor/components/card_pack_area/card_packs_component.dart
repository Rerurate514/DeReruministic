import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card_packs/data/card_packs.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_draggable.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card_pack_area/card_pack_section_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardPacksComponent extends ConsumerWidget {
  const CardPacksComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogMap = ref.watch(cardCatalogMapProvider);

    final list = CardPackTypes.values
        .map((cardPackType) => cardPacksTypes[cardPackType]!)
        .toList();

    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: list.map((pack) {
        return SliverMainAxisGroup(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: CardPackSectionHeaderDelegate(title: pack.packName),
            ),
            SliverList.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return DefCardDraggable(
                  defCard: catalogMap[pack.cardDefIds[index]]!,
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}

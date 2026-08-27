import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card_packs/entities/card_pack.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardPackComponent extends ConsumerWidget {
  const CardPackComponent({required this.cardPack, super.key});

  final CardPack cardPack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogMap = ref.watch(cardCatalogMapProvider);
    return Row(
      children: cardPack.cardDefIds
          .map(
            (id) => DefCardComponent(
              defCard: catalogMap[id]!,
            ),
          )
          .toList(),
    );
  }
}

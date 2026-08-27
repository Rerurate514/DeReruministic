import 'package:dereruministic/domain/card_packs/data/card_packs.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card_pack_area/card_pack_component.dart';
import 'package:flutter/material.dart';

class CardPacksComponent extends StatelessWidget {
  const CardPacksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CardPackTypes.values
            .map(
              (cardPackType) => CardPackComponent(
                cardPack: cardPacksTypes[cardPackType]!,
              ),
            )
            .toList(),
      ),
    );
  }
}

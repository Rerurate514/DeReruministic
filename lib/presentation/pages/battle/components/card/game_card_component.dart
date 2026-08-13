import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameCardComponent extends ConsumerWidget {
  const GameCardComponent({required this.defId, super.key});

  final CardDefinitionId defId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(cardCatalogMapProvider);
    final gameCard = catalog[defId];

    if (gameCard != null) return const SizedBox.shrink();

    return Text(gameCard.toString());
  }
}

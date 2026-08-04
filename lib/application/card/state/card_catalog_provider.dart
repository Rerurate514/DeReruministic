import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_catalog_provider.g.dart';

@riverpod
List<CardDefinition> cardCatalog(Ref ref) {
  throw UnimplementedError();
}

@riverpod
Map<CardDefinitionId, CardDefinition> cardCatalogMap(Ref ref) {
  final catalog = ref.watch(cardCatalogProvider);
  return {for (final card in catalog) card.cardDefId: card};
}

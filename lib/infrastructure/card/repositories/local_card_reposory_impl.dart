import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/repositories/i_card_repository.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card_packs/data/card_packs.dart';

class LocalCardRepositoryImpl implements ICardRepository {
  @override
  Future<List<CardDefinition>> fetchAllCards() {
    return Future(() => allCardDefinitions);
  }

  @override
  Future<CardDefinition?> fetchById(CardDefinitionId id) {
    return Future(
      () => allCardDefinitions.firstWhere((card) => card.cardDefId == id),
    );
  }

  @override
  Future<List<CardDefinition>> fetchByIds(List<CardDefinitionId> ids) {
    return Future(
      () => allCardDefinitions
          .where((card) => ids.contains(card.cardDefId))
          .toList(),
    );
  }
}

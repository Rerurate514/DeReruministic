import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/repositories/i_card_repository.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';

class LocalCardReposoryImpl implements ICardRepository {
  @override
  Future<List<CardDefinition>> fetchAllCards() {
    return Future(() => basicPack);
  }

  @override
  Future<CardDefinition?> fetchById(CardDefinitionId id) {
    return Future(() => basicPack.firstWhere((card) => card.cardDefId == id));
  }

  @override
  Future<List<CardDefinition>> fetchByIds(List<CardDefinitionId> ids) {
    return Future(
      () => basicPack.where((card) => ids.contains(card.cardDefId)).toList(),
    );
  }
}

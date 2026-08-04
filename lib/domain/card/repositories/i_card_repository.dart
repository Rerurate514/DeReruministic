import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';

abstract class ICardRepository {
  Future<List<CardDefinition>> fetchAllCards();
  Future<CardDefinition?> fetchById(CardDefinitionId id);
  Future<List<CardDefinition>> fetchByIds(List<CardDefinitionId> ids);
}

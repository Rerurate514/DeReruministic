import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class CardDefinitionIdConverter
    implements JsonConverter<CardDefinitionId, String> {
  const CardDefinitionIdConverter();

  @override
  CardDefinitionId fromJson(String json) => CardDefinitionId(value: json);

  @override
  String toJson(CardDefinitionId object) => object.value;
}

class CardDefinitionIdListConverter
    implements JsonConverter<List<CardDefinitionId>, List<dynamic>> {
  const CardDefinitionIdListConverter();

  @override
  List<CardDefinitionId> fromJson(List<dynamic> json) {
    return json.map((e) => CardDefinitionId(value: e as String)).toList();
  }

  @override
  List<dynamic> toJson(List<CardDefinitionId> object) {
    return object.map((e) => e.value).toList();
  }
}

import 'package:dereruministic/domain/create_deck_recipe/value_objects/deck_recipe_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DeckRecipeIdConverter implements JsonConverter<DeckRecipeId, String> {
  const DeckRecipeIdConverter();

  @override
  DeckRecipeId fromJson(String json) => DeckRecipeId(value: json);

  @override
  String toJson(DeckRecipeId object) => object.value;
}

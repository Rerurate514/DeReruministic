import 'package:dereruministic/domain/card/converter/card_definition_id_converter.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/converter/deck_recipe_id_converter.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/draft_deck_recipe.dart';
import 'package:dereruministic/domain/create_deck_recipe/value_objects/deck_recipe_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_recipe.freezed.dart';
part 'deck_recipe.g.dart';

@freezed
abstract class DeckRecipe with _$DeckRecipe {
  const factory DeckRecipe({
    @DeckRecipeIdConverter() required DeckRecipeId id,
    @CardDefinitionIdListConverter() required List<CardDefinitionId> cardDefIds,
  }) = _DeckRecipe;

  factory DeckRecipe.empty() {
    return DeckRecipe(id: DeckRecipeId.generate(), cardDefIds: []);
  }

  factory DeckRecipe.create(List<CardDefinitionId> ids) {
    return DeckRecipe(id: DeckRecipeId.generate(), cardDefIds: ids);
  }

  factory DeckRecipe.createFromDraft(DraftDeckRecipe draft) {
    return DeckRecipe(id: draft.id, cardDefIds: draft.cardDefIds);
  }

  factory DeckRecipe.fromJson(Map<String, dynamic> json) =>
      _$DeckRecipeFromJson(json);

  const DeckRecipe._();

  int get cardsCount => cardDefIds.length;
}

import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/draft_deck_recipe.dart';
import 'package:dereruministic/domain/create_deck_recipe/value_objects/deck_recipe_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/value_objects/try_add_card_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_recipe.freezed.dart';
part 'deck_recipe.g.dart';

typedef AddCardResult = (
  DeckRecipe deckRecipe,
  TryAddCardResult result,
);

@freezed
abstract class DeckRecipe with _$DeckRecipe {
  const factory DeckRecipe({
    required DeckRecipeId id,
    required List<CardDefinitionId> cardDefIds,
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

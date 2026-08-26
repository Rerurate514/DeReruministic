import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/constants/create_deck_recipe_rules.dart';
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

  factory DeckRecipe.fromJson(Map<String, dynamic> json) =>
      _$DeckRecipeFromJson(json);

  const DeckRecipe._();

  int get cardsCount => cardDefIds.length;
  bool get isDeckFull => cardsCount >= CreateDeckRecipeRules.maxDeckCards;

  TryAddCardResult validateAddCard(CardDefinitionId newCardDefId) {
    if (cardDefIds.length >= CreateDeckRecipeRules.maxDeckCards) {
      return TryAddCardResult.failedToMaxDeckCards;
    }

    final sameCardsCount = countOf(newCardDefId);
    if (sameCardsCount >= CreateDeckRecipeRules.maxSameCards) {
      return TryAddCardResult.failedToMaxSameCards;
    }

    return TryAddCardResult.success;
  }

  AddCardResult tryAddCard(
    CardDefinitionId newCardDefId,
  ) {
    final canAddCardReason = validateAddCard(newCardDefId);
    if (canAddCardReason != TryAddCardResult.success) {
      return (this, canAddCardReason);
    }

    final newDeckRecipe = copyWith(
      cardDefIds: [...cardDefIds, newCardDefId],
    );

    return (newDeckRecipe, canAddCardReason);
  }

  DeckRecipe removeCardAt(int index) {
    final newCardDefIds = [...cardDefIds]..removeAt(index);
    return copyWith(
      cardDefIds: newCardDefIds,
    );
  }

  DeckRecipe clear() {
    return copyWith(cardDefIds: []);
  }

  int countOf(CardDefinitionId cardDefId) {
    return cardDefIds.where((cardDefId) => cardDefId == cardDefId).length;
  }
}

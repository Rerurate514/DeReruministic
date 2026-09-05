import 'package:dereruministic/domain/card/converter/card_definition_id_converter.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/constants/create_deck_recipe_rules.dart';
import 'package:dereruministic/domain/create_deck_recipe/converter/deck_recipe_id_converter.dart';
import 'package:dereruministic/domain/create_deck_recipe/value_objects/deck_recipe_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/value_objects/try_add_card_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_deck_recipe.freezed.dart';
part 'draft_deck_recipe.g.dart';

typedef AddCardResult = ({
  DraftDeckRecipe draftDeckRecipe,
  TryAddCardResult result,
});

@freezed
abstract class DraftDeckRecipe with _$DraftDeckRecipe {
  const factory DraftDeckRecipe({
    @DeckRecipeIdConverter() required DeckRecipeId id,
    @CardDefinitionIdListConverter() required List<CardDefinitionId> cardDefIds,
  }) = _DraftDeckRecipe;

  factory DraftDeckRecipe.empty() {
    return DraftDeckRecipe(id: DeckRecipeId.generate(), cardDefIds: []);
  }

  factory DraftDeckRecipe.create(List<CardDefinitionId> ids) {
    return DraftDeckRecipe(id: DeckRecipeId.generate(), cardDefIds: ids);
  }

  factory DraftDeckRecipe.fromJson(Map<String, dynamic> json) =>
      _$DraftDeckRecipeFromJson(json);

  const DraftDeckRecipe._();

  int get cardsCount => cardDefIds.length;
  bool get isDeckFull => cardsCount >= CreateDeckRecipeRules.maxDeckCards;
  bool isSameCardMax(CardDefinitionId newCardDefId) {
    final sameCardsCount = countOf(newCardDefId);
    return sameCardsCount >= CreateDeckRecipeRules.maxSameCards;
  }

  TryAddCardResult validateAddCard(CardDefinitionId newCardDefId) {
    if (isDeckFull) {
      return TryAddCardResult.failedToMaxDeckCards;
    }

    if (isSameCardMax(newCardDefId)) {
      return TryAddCardResult.failedToMaxSameCards;
    }

    return TryAddCardResult.success;
  }

  AddCardResult tryAddCard(
    CardDefinitionId newCardDefId,
  ) {
    final canAddCardResult = validateAddCard(newCardDefId);
    if (canAddCardResult != TryAddCardResult.success) {
      return (draftDeckRecipe: this, result: canAddCardResult);
    }

    final newDraftDeckRecipe = copyWith(
      cardDefIds: [...cardDefIds, newCardDefId],
    );

    return (draftDeckRecipe: newDraftDeckRecipe, result: canAddCardResult);
  }

  DraftDeckRecipe removeCardAt(int index) {
    final newCardDefIds = [...cardDefIds]..removeAt(index);
    return copyWith(
      cardDefIds: newCardDefIds,
    );
  }

  DraftDeckRecipe clear() {
    return copyWith(cardDefIds: []);
  }

  int countOf(CardDefinitionId newCardDefId) {
    return cardDefIds.where((id) => id == newCardDefId).length;
  }
}

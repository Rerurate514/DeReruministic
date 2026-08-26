import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/draft_deck_recipe.dart';
import 'package:dereruministic/domain/create_deck_recipe/value_objects/try_add_card_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'draft_deck_recipe_notifier.g.dart';

@riverpod
class DraftDeckRecipeNotifier extends _$DraftDeckRecipeNotifier {
  @override
  DraftDeckRecipe build() {
    return DraftDeckRecipe.empty();
  }

  TryAddCardResult addCard(CardDefinitionId newCardDefId) {
    final newDraftState = state.tryAddCard(newCardDefId);
    if (newDraftState.result == TryAddCardResult.success) {
      state = newDraftState.draftDeckRecipe;
    }
    return newDraftState.result;
  }

  void removeAt(int index) {
    state = state.removeCardAt(index);
  }

  void clear() {
    state = state.clear();
  }
}

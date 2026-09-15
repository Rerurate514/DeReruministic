import 'package:dereruministic/application/create_deck_recipe/usecases/save_current_user_deck_recipe_usecase.dart';
import 'package:dereruministic/domain/create_deck_recipe/constants/create_deck_recipe_rules.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/draft_deck_recipe_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_deck_recipe_notifier.g.dart';

@riverpod
class SaveDeckRecipeNotifier extends _$SaveDeckRecipeNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> execute() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final draftDeckRecipe = ref.read(draftDeckRecipeProvider);
      if (draftDeckRecipe.cardsCount != CreateDeckRecipeRules.maxDeckCards) {
        throw const SaveDeckRecipeFailure.incompleteDeck();
      }

      await ref
          .read(saveCurrentUserDeckRecipeUsecaseProvider)
          .execute(draftDeckRecipe);
    });
  }
}

sealed class SaveDeckRecipeFailure implements Exception {
  const factory SaveDeckRecipeFailure.incompleteDeck() =
      SaveDeckRecipeFailureIncompleteDeck;
}

class SaveDeckRecipeFailureIncompleteDeck implements SaveDeckRecipeFailure {
  const SaveDeckRecipeFailureIncompleteDeck();
}

import 'package:dereruministic/application/auth/state/auth_provider.dart';
import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/draft_deck_recipe.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_current_user_deck_recipe_usecase.g.dart';

@riverpod
SaveCurrentUserDeckRecipeUsecase saveCurrentUserDeckRecipeUsecase(Ref ref) {
  return SaveCurrentUserDeckRecipeUsecase(
    userRepository: ref.watch(userRepositoryProvider),
    currentUserId: ref.watch(authProvider).value?.uid,
  );
}

class SaveCurrentUserDeckRecipeUsecase {
  SaveCurrentUserDeckRecipeUsecase({
    required this.userRepository,
    required this.currentUserId,
  });

  final IUserRepository userRepository;
  final String? currentUserId;

  Future<void> execute(DraftDeckRecipe draftDeckRecipe) async {
    final userId = currentUserId;
    if (userId == null) return;

    await userRepository.saveDeckRecipe(
      playerId: PlayerId(value: userId),
      deckRecipe: DeckRecipe.createFromDraft(draftDeckRecipe),
    );
  }
}

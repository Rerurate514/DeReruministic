import 'package:dereruministic/di/providers/auth/auth_repository_provider.dart';
import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_github_usecase.g.dart';

@riverpod
SignInWithGitHubUsecase signInWithGitHubUsecase(Ref ref) {
  return SignInWithGitHubUsecase(
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
}

class SignInWithGitHubUsecase {
  SignInWithGitHubUsecase({
    required this.authRepository,
    required this.userRepository,
  });

  final IAuthRepository authRepository;
  final IUserRepository userRepository;

  Future<PlayerId?> signIn() async {
    final playerId = await authRepository.signInWithGitHub();
    if (playerId == null) return null;

    await userRepository.save(
      Player(
        id: playerId,
        name: 'Player_${playerId.value.substring(0, 6)}',
        deckRecipe: DeckRecipe.empty(),
      ),
    );
    return playerId;
  }
}

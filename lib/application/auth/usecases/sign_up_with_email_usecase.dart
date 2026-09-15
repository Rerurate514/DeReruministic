import 'package:dereruministic/di/providers/auth/auth_repository_provider.dart';
import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_with_email_usecase.g.dart';

@riverpod
SignUpWithEmailUsecase signUpWithEmailUsecase(Ref ref) {
  return SignUpWithEmailUsecase(
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
}

class SignUpWithEmailUsecase {
  SignUpWithEmailUsecase({
    required this.authRepository,
    required this.userRepository,
  });

  final IAuthRepository authRepository;
  final IUserRepository userRepository;

  Future<PlayerId?> signUp({
    required String email,
    required String password,
  }) async {
    final playerId = await authRepository.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (playerId == null) return null;

    await userRepository.save(
      Player(
        id: playerId,
        name: email.split('@').first,
        deckRecipe: DeckRecipe.empty(),
      ),
    );
    return playerId;
  }
}

import 'package:dereruministic/di/providers/auth/auth_provider.dart';
import 'package:dereruministic/di/providers/auth/auth_repository_provider.dart';
import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_with_google_usecase.g.dart';

@riverpod
SignUpWithGoogleUsecase signUpWithGoogleUsecase(Ref ref) {
  return SignUpWithGoogleUsecase(
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
}

class SignUpWithGoogleUsecase {
  SignUpWithGoogleUsecase({
    required this.authRepository,
    required this.userRepository,
  });

  final IAuthRepository authRepository;
  final IUserRepository userRepository;

  Future<Player> signUp() async {
    final credential = await authRepository.signInWithGoogle();
    if (credential != null) {
      userRepository.createOrUpdateUserDoc(credential.user!, );
    }
  }
}

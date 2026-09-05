import 'package:dereruministic/di/providers/auth/auth_repository_provider.dart';
import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_google_usecase.g.dart';

@riverpod
SignInWithGoogleUsecase signInWithGoogleUsecase(Ref ref) {
  return SignInWithGoogleUsecase(
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
}

class SignInWithGoogleUsecase {
  SignInWithGoogleUsecase({
    required this.userRepository,
    required this.authRepository,
  });

  final IAuthRepository authRepository;
  final IUserRepository userRepository;

  Future<void> signIn() async {
    final credential = await authRepository.signInWithGoogle();
    if (credential != null) {
      //await userRepository.createOr
    }
  }
}

import 'package:dereruministic/di/providers/auth/auth_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_email_usecase.g.dart';

@riverpod
SignInWithEmailUsecase signInWithEmailUsecase(Ref ref) {
  return SignInWithEmailUsecase(
    authRepository: ref.watch(authRepositoryProvider),
  );
}

class SignInWithEmailUsecase {
  SignInWithEmailUsecase({required this.authRepository});

  final IAuthRepository authRepository;

  Future<PlayerId?> signIn({
    required String email,
    required String password,
  }) {
    return authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

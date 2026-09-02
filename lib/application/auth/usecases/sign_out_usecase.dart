import 'package:dereruministic/di/providers/auth/auth_repository_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_usecase.g.dart';

@riverpod
SignOutUsecase signOutUsecase(Ref ref) {
  return SignOutUsecase(
    authRepository: ref.watch(authRepositoryProvider),
  );
}

class SignOutUsecase {
  SignOutUsecase({required this.authRepository});

  final IAuthRepository authRepository;
  Future<void> signOut() async {
    await authRepository.signOut();
  }
}

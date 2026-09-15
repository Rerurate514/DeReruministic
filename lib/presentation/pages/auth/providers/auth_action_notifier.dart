import 'package:dereruministic/application/auth/usecases/sign_in_with_email_usecase.dart';
import 'package:dereruministic/application/auth/usecases/sign_in_with_github_usecase.dart';
import 'package:dereruministic/application/auth/usecases/sign_in_with_google_usecase.dart';
import 'package:dereruministic/application/auth/usecases/sign_up_with_email_usecase.dart';
import 'package:dereruministic/presentation/pages/auth/state/auth_action_failure.dart';
import 'package:dereruministic/presentation/pages/auth/state/auth_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_action_notifier.g.dart';

@riverpod
class AuthActionNotifier extends _$AuthActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required AuthMode mode,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final normalizedEmail = email.trim();
      if (mode == AuthMode.signUp) {
        await ref
            .read(signUpWithEmailUsecaseProvider)
            .signUp(
              email: normalizedEmail,
              password: password,
            );
      } else {
        await ref
            .read(signInWithEmailUsecaseProvider)
            .signIn(
              email: normalizedEmail,
              password: password,
            );
      }
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(signInWithGoogleUsecaseProvider).signIn();
      if (result == null) {
        throw AuthActionFailure.googleSignInCanceled;
      }
    });
  }

  Future<void> signInWithGitHub() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(signInWithGitHubUsecaseProvider).signIn();
      if (result == null) {
        throw AuthActionFailure.githubSignInCanceled;
      }
    });
  }
}

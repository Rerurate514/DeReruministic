import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/auth/state/auth_action_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

String resolveAuthErrorMessage({
  required Object? error,
  required AppLocalizations l10n,
}) {
  return switch (error) {
    FirebaseAuthException() => error.toAuthErrorMessage(l10n),
    AuthActionFailure.googleSignInCanceled =>
      l10n.auth_page_errorGoogleCanceled,
    AuthActionFailure.githubSignInCanceled =>
      l10n.auth_page_errorGithubCanceled,
    _ => l10n.auth_page_defaultErrorMessage,
  };
}

extension FirebaseAuthExceptionEx on FirebaseAuthException {
  String toAuthErrorMessage(AppLocalizations l10n) {
    return switch (code) {
      'invalid-email' => l10n.auth_page_errorInvalidEmail,
      'user-disabled' => l10n.auth_page_errorUserDisabled,
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => l10n.auth_page_errorInvalidCredential,
      'email-already-in-use' => l10n.auth_page_errorEmailAlreadyInUse,
      'weak-password' => l10n.auth_page_errorWeakPassword,
      'operation-not-allowed' => l10n.auth_page_errorOperationNotAllowed,
      'account-exists-with-different-credential' =>
        l10n.auth_page_errorAccountExistsWithDifferentCredential,
      'google-sign-in-canceled' => l10n.auth_page_errorGoogleCanceled,
      'github-sign-in-canceled' => l10n.auth_page_errorGithubCanceled,
      _ => l10n.auth_page_errorUnknown(message ?? code),
    };
  }
}

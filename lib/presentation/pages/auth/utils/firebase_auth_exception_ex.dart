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
      l10n.auth_page_error_google_canceled,
    AuthActionFailure.githubSignInCanceled =>
      l10n.auth_page_error_github_canceled,
    _ => l10n.auth_page_default_error_message,
  };
}

extension FirebaseAuthExceptionEx on FirebaseAuthException {
  String toAuthErrorMessage(AppLocalizations l10n) {
    return switch (code) {
      'invalid-email' => l10n.auth_page_error_invalid_email,
      'user-disabled' => l10n.auth_page_error_user_disabled,
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => l10n.auth_page_error_invalid_credential,
      'email-already-in-use' => l10n.auth_page_error_email_already_in_use,
      'weak-password' => l10n.auth_page_error_weak_password,
      'operation-not-allowed' => l10n.auth_page_error_operation_not_allowed,
      'account-exists-with-different-credential' =>
        l10n.auth_page_error_account_exists_with_different_credential,
      'google-sign-in-canceled' => l10n.auth_page_error_google_canceled,
      'github-sign-in-canceled' => l10n.auth_page_error_github_canceled,
      _ => l10n.auth_page_error_unknown(message ?? code),
    };
  }
}

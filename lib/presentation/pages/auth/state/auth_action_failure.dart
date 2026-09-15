enum AuthActionFailure implements Exception {
  googleSignInCanceled('google-sign-in-canceled'),
  githubSignInCanceled('github-sign-in-canceled');

  const AuthActionFailure(this.code);

  final String code;

  @override
  String toString() {
    return code;
  }
}

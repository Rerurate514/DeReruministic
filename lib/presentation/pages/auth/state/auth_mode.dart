enum AuthMode {
  signIn,
  signUp;

  AuthMode get toggled {
    return switch (this) {
      AuthMode.signIn => AuthMode.signUp,
      AuthMode.signUp => AuthMode.signIn,
    };
  }
}

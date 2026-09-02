import 'package:firebase_auth/firebase_auth.dart';

abstract interface class IAuthRepository {
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
}

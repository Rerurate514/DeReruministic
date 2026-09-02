import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepositoryImpl implements IAuthRepository {
  FirebaseAuthRepositoryImpl({required this.googleSignIn, required this.auth});

  final GoogleSignIn googleSignIn;
  final FirebaseAuth auth;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;

      final authorization = await googleUser.authorizationClient
          .authorizeScopes(
            ['email', 'profile'],
          );

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization.accessToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      return userCredential;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}

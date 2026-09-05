import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepositoryImpl implements IAuthRepository {
  FirebaseAuthRepositoryImpl({
    required this.firestore,
    required this.googleSignIn,
    required this.auth,
  });

  final GoogleSignIn googleSignIn;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  Future<PlayerId?> signInWithGoogle() async {
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
      if (userCredential.user == null) return null;
      return PlayerId(value: userCredential.user!.uid);
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

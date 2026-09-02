import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/infrastructure/auth/constants/collections.dart';
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
  Future<UserCredential?> signInWithGoogle(Player player) async {
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
      if (userCredential.user != null) {
        await _createOrUpdateUserDoc(userCredential.user!, player);
      }
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

  Future<void> _createOrUpdateUserDoc(User user, Player player) async {
    final userRef = firestore.collection(Collections.users).doc(user.uid);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        transaction.set(userRef, {
          ...player.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.update(userRef, {
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}

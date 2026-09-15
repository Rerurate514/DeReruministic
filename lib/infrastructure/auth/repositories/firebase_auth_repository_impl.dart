import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  Future<PlayerId?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) return null;
    return PlayerId(value: user.uid);
  }

  @override
  Future<PlayerId?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) return null;
    return PlayerId(value: user.uid);
  }

  @override
  Future<PlayerId?> signInWithGoogle() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
      return null;
    }

    try {
      if (kIsWeb ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        final userCredential = await auth.signInWithProvider(
          GoogleAuthProvider(),
        );
        final user = userCredential.user;
        if (user == null) return null;
        return PlayerId(value: user.uid);
      }

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
  Future<PlayerId?> signInWithGitHub() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
      return null;
    }

    final userCredential = await auth.signInWithProvider(GithubAuthProvider());
    final user = userCredential.user;
    if (user == null) return null;
    return PlayerId(value: user.uid);
  }

  @override
  Future<void> signOut() async {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      await googleSignIn.signOut();
    }
    await auth.signOut();
  }
}

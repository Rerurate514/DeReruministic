import 'package:dereruministic/domain/player/value_objects/player_id.dart';

abstract interface class IAuthRepository {
  Future<PlayerId?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<PlayerId?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<PlayerId?> signInWithGoogle();
  Future<PlayerId?> signInWithGitHub();
  Future<void> signOut();
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class IAuthRepository {
  Future<UserCredential?> signInWithGoogle(Player player);
  Future<void> signOut();
}

import 'package:dereruministic/domain/player/value_objects/player_id.dart';

abstract interface class IAuthRepository {
  Future<PlayerId?> signInWithGoogle();
  Future<void> signOut();
}

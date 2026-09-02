import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class IUserRepository {
  Future<void> createOrUpdateUserDoc(User user, Player player);
}

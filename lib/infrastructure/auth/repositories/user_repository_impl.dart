import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/infrastructure/auth/constants/collections.dart';

class UserRepositoryImpl implements IUserRepository {
  UserRepositoryImpl({required this.firestore});

  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> _userRef(PlayerId playerId) {
    return firestore.collection(Collections.users).doc(playerId.value);
  }

  @override
  Future<void> save(Player player) async {
    final userRef = _userRef(player.id);

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

  @override
  Future<void> saveDeckRecipe({
    required PlayerId playerId,
    required DeckRecipe deckRecipe,
  }) async {
    await _userRef(playerId).update({
      'deckRecipe': deckRecipe.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Player?> watch(PlayerId playerId) {
    return _userRef(playerId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return Player.fromJson(data);
    });
  }
}

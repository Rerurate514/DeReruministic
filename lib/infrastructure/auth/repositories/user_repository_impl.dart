import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/infrastructure/auth/constants/collections.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl implements IUserRepository {
  UserRepositoryImpl({required this.firestore});

  final FirebaseFirestore firestore;
  @override
  Future<void> createOrUpdateUserDoc(User user, Player player) async {
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

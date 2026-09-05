import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/remote_sync/in_game/repositories/i_game_actions_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/infrastructure/auth/constants/collections.dart';

class FirebaseGameActionsRepositoryImpl implements IGameActionsRepository {
  FirebaseGameActionsRepositoryImpl({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _getGameActionsRef(RoomId roomId) =>
      firestore
          .collection(Collections.rooms)
          .doc(roomId.value)
          .collection(Collections.gameActions);

  @override
  Future<void> appendAction({
    required RoomId roomId,
    required GameActions action,
  }) async {
    final actionJson = action.toJson();
    await _getGameActionsRef(roomId).add(actionJson);
  }

  @override
  Stream<List<GameActions>> watchActions({required RoomId roomId}) {
    return _getGameActionsRef(
      roomId,
    ).orderBy('actionSequenceNumber', descending: false).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => GameActions.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Stream<GameActions> watchAddedActions({required RoomId roomId}) {
    return _getGameActionsRef(roomId)
        .orderBy('actionSequenceNumber', descending: false)
        .snapshots()
        .expand((snapshot) {
          return snapshot.docChanges
              .where((change) => change.type == DocumentChangeType.added)
              .map((change) => GameActions.fromJson(change.doc.data()!));
        });
  }
}

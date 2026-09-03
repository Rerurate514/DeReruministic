import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/room/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/join_room_result.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_start_game_result.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_status.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/infrastructure/auth/constants/collections.dart';

class FirebaseRoomRepositoryImpl implements IRoomRepository {
  FirebaseRoomRepositoryImpl({required this.firestore});

  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> _getRoomRef(RoomId roomId) =>
      firestore.collection(Collections.rooms).doc(roomId.value);

  @override
  Future<Room> createRoom({required PlayerId hostPlayerId}) async {
    final room = Room(
      roomId: RoomId.generate(),
      hostPlayerId: hostPlayerId,
      guestPlayerId: null,
      status: RoomStatus.waiting,
      createdAt: Timestamp.now(), //TODO(low): クライアント時間ではなく、サーバー時間を使用する
      updatedAt: Timestamp.now(), //TODO(low): クライアント時間ではなく、サーバー時間を使用する
    );

    await _getRoomRef(room.roomId).set(room.toJson());

    return room;
  }

  @override
  Future<JoinRoomResult> joinRoom({
    required RoomId roomId,
    required PlayerId guestPlayerId,
  }) async {
    final roomRef = _getRoomRef(roomId);

    return firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(roomRef);

      if (!snapshot.exists) {
        return const JoinRoomResult.roomNotFound();
      }

      final data = snapshot.data()!;

      if (data['guestPlayerId'] != null) {
        return const JoinRoomResult.roomAlreadyFull();
      }

      if (data['status'] == RoomStatus.closed) {
        return const JoinRoomResult.roomAlreadyClosed();
      }

      transaction.update(roomRef, {
        'guestPlayerId': guestPlayerId.value,
        'status': RoomStatus.ready,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return JoinRoomResult.success(
        room: Room.fromJson({
          ...data,
          'guestPlayerId': guestPlayerId.value,
          'status': RoomStatus.ready.name,
          'updatedAt': Timestamp.now(),
        }),
      );
    });
  }

  @override
  Future<RoomStartGameResult> startGame({required RoomId roomId}) async {
    final roomRef = _getRoomRef(roomId);

    return firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(roomRef);

      if (!snapshot.exists) {
        return const RoomStartGameResult.roomNotFound();
      }

      final data = snapshot.data()!;

      if (data['guestPlayerId'] == null) {
        return const RoomStartGameResult.guestPlayerNotFound();
      }

      transaction.update(roomRef, {
        'status': RoomStatus.playing,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return RoomStartGameResult.success(
        room: Room.fromJson({
          ...data,
          'status': RoomStatus.playing.name,
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );
    });
  }

  @override
  Stream<RoomWatchResult> watchRoom({required RoomId roomId}) {
    return _getRoomRef(roomId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return const RoomWatchResult.unavailable();
      }

      return RoomWatchResult.available(
        room: Room.fromJson({
          ...snapshot.data()!,
          'roomId': snapshot.id,
        }),
      );
    });
  }

  @override
  Future<void> leaveRoom({
    required RoomId roomId,
    required PlayerId playerId,
  }) async {
    final roomRef = _getRoomRef(roomId);

    return firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(roomRef);

      if (!snapshot.exists) {
        return;
      }

      final data = snapshot.data()!;

      if (data['hostPlayerId'] == playerId) {
        transaction.update(roomRef, {
          'status': RoomStatus.closed,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.update(roomRef, {
          'guestPlayerId': null,
          'status': RoomStatus.waiting,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Future<Room?> getRoom({required RoomId roomId}) async {
    final snapshot = await _getRoomRef(roomId).get();
    final data = snapshot.data();

    if (data == null) return null;

    return Room.fromJson(data);
  }
}

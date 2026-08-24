import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_status.dart';

class FirebaseRoomRepositoryImpl implements IRoomRepository {
  @override
  Future<void> createRoom(Room room) {
    // TODO: implement createRoom
    throw UnimplementedError();
  }

  @override
  Future<void> joinRoom({
    required RoomId roomId,
    required PlayerId guestPlayerId,
  }) {
    // TODO: implement joinRoom
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus({
    required RoomId roomId,
    required RoomStatus status,
  }) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }

  @override
  Stream<Room> watchRoom({required RoomId roomId}) {
    // TODO: implement watchRoom
    throw UnimplementedError();
  }
}

import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_status.dart';

abstract interface class IRoomRepository {
  Future<void> createRoom(Room room);
  Future<void> joinRoom({
    required RoomId roomId,
    required PlayerId guestPlayerId,
  });
  Stream<Room> watchRoom({required RoomId roomId});
  Future<void> updateStatus({
    required RoomId roomId,
    required RoomStatus status,
  });
}

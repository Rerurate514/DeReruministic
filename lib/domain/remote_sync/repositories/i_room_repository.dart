import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_watch_result.dart';

abstract interface class IRoomRepository {
  Future<Room> createRoom({required PlayerId hostPlayerId});
  Future<Room> joinRoom({
    required RoomId roomId,
    required PlayerId guestPlayerId,
  });
  Stream<RoomWatchResult> watchRoom({required RoomId roomId});
  Future<Room> startGame({required RoomId roomId});
}

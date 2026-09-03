import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/join_room_result.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_start_game_result.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';

abstract interface class IRoomRepository {
  Future<Room> createRoom({required PlayerId hostPlayerId});
  Future<JoinRoomResult> joinRoom({
    required RoomId roomId,
    required PlayerId guestPlayerId,
  });
  Stream<RoomWatchResult> watchRoom({required RoomId roomId});
  Future<RoomStartGameResult> startGame({required RoomId roomId});
  Future<void> leaveRoom({
    required RoomId roomId,
    required PlayerId playerId,
  });
  Future<Room?> getRoom({required RoomId roomId});
}

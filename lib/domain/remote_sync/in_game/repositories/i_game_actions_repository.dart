import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';

abstract interface class IGameActionsRepository {
  Future<void> appendAction({
    required RoomId roomId,
    required GameActions action,
  });
  Stream<List<GameActions>> watchActions({required RoomId roomId});
}

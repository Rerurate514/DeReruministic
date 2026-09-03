import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/remote_sync/in_game/repositories/i_game_actions_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';

class FirebaseGameActionsRepositoryImpl implements IGameActionsRepository {
  @override
  Future<void> appendAction({
    required RoomId roomId,
    required GameActions action,
  }) {
    // TODO: implement appendAction
    throw UnimplementedError();
  }

  @override
  Stream<List<GameActions>> watchActions({required RoomId roomId}) {
    // TODO: implement watchActions
    throw UnimplementedError();
  }
}

import 'package:dereruministic/di/providers/remote_sync/in_game/game_actions_repository_provider.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_actions_watch_provider.g.dart';

@riverpod
Stream<List<GameActions>> gameActionsWatch(Ref ref, {required RoomId roomId}) {
  final repository = ref.watch(gameActionsRepositoryProvider);
  return repository.watchActions(roomId: roomId);
}

@riverpod
Stream<GameActions> gameActionsAddedWatch(Ref ref, {required RoomId roomId}) {
  final repository = ref.watch(gameActionsRepositoryProvider);
  return repository.watchAddedActions(roomId: roomId);
}

import 'package:dereruministic/di/providers/room/room_repository_provider.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_watch_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_watch_provider.g.dart';

@riverpod
Stream<RoomWatchResult> roomWatch(Ref ref, {required RoomId roomId}) {
  final repository = ref.watch(roomRepositoryProvider);
  return repository.watchRoom(roomId: roomId);
}

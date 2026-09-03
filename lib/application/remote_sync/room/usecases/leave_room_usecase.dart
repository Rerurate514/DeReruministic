import 'package:dereruministic/di/providers/remote_sync/room/room_repository_provider.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/room/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_room_usecase.g.dart';

@riverpod
LeaveRoomUseCase leaveRoomUseCase(Ref ref) {
  return LeaveRoomUseCase(roomRepository: ref.watch(roomRepositoryProvider));
}

class LeaveRoomUseCase {
  LeaveRoomUseCase({required this.roomRepository});

  final IRoomRepository roomRepository;

  Future<void> execute({
    required RoomId roomId,
    required PlayerId playerId,
  }) {
    return roomRepository.leaveRoom(roomId: roomId, playerId: playerId);
  }
}

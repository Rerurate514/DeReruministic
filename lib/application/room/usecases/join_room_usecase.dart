import 'package:dereruministic/di/providers/room/room_repository_provider.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/join_room_result.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'join_room_usecase.g.dart';

@riverpod
JoinRoomUseCase joinRoomUseCase(Ref ref) {
  return JoinRoomUseCase(roomRepository: ref.watch(roomRepositoryProvider));
}

class JoinRoomUseCase {
  JoinRoomUseCase({required this.roomRepository});

  final IRoomRepository roomRepository;

  Future<JoinRoomResult> execute({
    required RoomId roomId,
    required PlayerId guestPlayerId,
  }) {
    return roomRepository.joinRoom(
      roomId: roomId,
      guestPlayerId: guestPlayerId,
    );
  }
}

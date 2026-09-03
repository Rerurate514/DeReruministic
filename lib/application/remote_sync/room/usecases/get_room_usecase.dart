import 'package:dereruministic/di/providers/remote_sync/room/room_repository_provider.dart';
import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/room/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_room_usecase.g.dart';

@riverpod
GetRoomUseCase getRoomUseCase(Ref ref) {
  return GetRoomUseCase(roomRepository: ref.watch(roomRepositoryProvider));
}

class GetRoomUseCase {
  GetRoomUseCase({required this.roomRepository});

  final IRoomRepository roomRepository;

  Future<Room?> execute({required RoomId roomId}) {
    return roomRepository.getRoom(roomId: roomId);
  }
}

import 'package:dereruministic/di/providers/room/room_repository_provider.dart';
import 'package:dereruministic/domain/remote_sync/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
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

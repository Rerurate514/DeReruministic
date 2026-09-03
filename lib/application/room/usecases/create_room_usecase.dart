import 'package:dereruministic/di/providers/room/room_repository_provider.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/repositories/i_room_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_room_usecase.g.dart';

@riverpod
CreateRoomUseCase createRoomUseCase(Ref ref) {
  return CreateRoomUseCase(roomRepository: ref.watch(roomRepositoryProvider));
}

class CreateRoomUseCase {
  CreateRoomUseCase({required this.roomRepository});

  final IRoomRepository roomRepository;

  Future<Room> execute({required PlayerId hostPlayerId}) {
    return roomRepository.createRoom(hostPlayerId: hostPlayerId);
  }
}

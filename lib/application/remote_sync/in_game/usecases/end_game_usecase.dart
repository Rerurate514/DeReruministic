import 'package:dereruministic/di/providers/remote_sync/room/room_repository_provider.dart';
import 'package:dereruministic/domain/remote_sync/room/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'end_game_usecase.g.dart';

@riverpod
EndGameUseCase endGameUseCase(Ref ref) {
  return EndGameUseCase(roomRepository: ref.watch(roomRepositoryProvider));
}

class EndGameUseCase {
  EndGameUseCase({required this.roomRepository});

  final IRoomRepository roomRepository;

  Future<void> execute({required RoomId roomId}) {
    return roomRepository.endGame(roomId: roomId);
  }
}

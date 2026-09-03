import 'package:dereruministic/di/providers/room/room_repository_provider.dart';
import 'package:dereruministic/domain/remote_sync/repositories/i_room_repository.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_start_game_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'start_game_usecase.g.dart';

@riverpod
StartGameUseCase startGameUseCase(Ref ref) {
  return StartGameUseCase(roomRepository: ref.watch(roomRepositoryProvider));
}

class StartGameUseCase {
  StartGameUseCase({required this.roomRepository});

  final IRoomRepository roomRepository;

  Future<RoomStartGameResult> execute({required RoomId roomId}) {
    return roomRepository.startGame(roomId: roomId);
  }
}

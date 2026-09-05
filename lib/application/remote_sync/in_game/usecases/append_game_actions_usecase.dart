import 'package:dereruministic/di/providers/remote_sync/in_game/game_actions_repository_provider.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/remote_sync/in_game/repositories/i_game_actions_repository.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'append_game_actions_usecase.g.dart';

@riverpod
AppendGameActionsUsecase appendGameActionsUsecase(Ref ref) {
  return AppendGameActionsUsecase(
    gameActionsRepository: ref.watch(gameActionsRepositoryProvider),
  );
}

class AppendGameActionsUsecase {
  AppendGameActionsUsecase({required this.gameActionsRepository});

  final IGameActionsRepository gameActionsRepository;

  Future<void> execute({
    required RoomId roomId,
    required GameActions action,
  }) async {
    await gameActionsRepository.appendAction(roomId: roomId, action: action);
  }
}

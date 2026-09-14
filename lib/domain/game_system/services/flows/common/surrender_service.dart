import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'surrender_service.g.dart';

@riverpod
SurrenderService surrenderService(Ref ref) {
  return SurrenderService();
}

class SurrenderService {
  ApplyActionResult execute({
    required GameState state,
    required PlayerId winPlayerId,
  }) {
    final newState = state.pushTask(
      GameStateTaskPushPos.head,
      .auto(.gameEnd(winPlayer: winPlayerId)),
    );

    return ApplyActionResult.success(state: newState, steps: []);
  }
}

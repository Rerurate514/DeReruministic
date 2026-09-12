import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_discard_service.g.dart';

@riverpod
ApplyDiscardService applyDiscardService(Ref ref) {
  return ApplyDiscardService();
}

class ApplyDiscardService {
  ApplyActionResult execute(
    GameState state,
    GameActionSelectOverflowDiscards action,
  ) {
    final player = state.players[action.playerId];
    if (player == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final task = GameTask.auto(
      .moveCardZone(
        playerId: action.playerId,
        instanceIds: action.selectedCardInstanceIds,
        zoneFrom: CardZone.hand,
        zoneTo: CardZone.graveyard,
      ),
    );

    final newState = state.popTask().pushTask(
      GameStateTaskPushPos.head,
      task,
    );

    return ApplyActionResult.success(state: newState, steps: []);
  }
}

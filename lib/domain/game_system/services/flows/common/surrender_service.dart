import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_end_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
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
    final winner = state.players[winPlayerId];
    final loser = state.getOtherPlayer(winPlayerId);

    if (winner == null || loser == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newState = state.popTask().copyWith(
      phase: state.phase.copyWith(battlePhase: .battleEnd),
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [
        GameStepEvent.gameEnded(
          endResult: GameEndResult.winnerDecided,
          winnerPlayerId: winner.id,
          loserPlayerId: loser.id,
          reason: DefeatReason.surrender,
        ),
      ],
    );
  }
}

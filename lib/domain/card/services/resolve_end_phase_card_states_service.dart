import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_end_phase_card_states_service.g.dart';

@riverpod
ResolveEndPhaseCardStatesService resolveEndPhaseCardStatesService(Ref ref) {
  return const ResolveEndPhaseCardStatesService();
}

class ResolveEndPhaseCardStatesService {
  const ResolveEndPhaseCardStatesService();

  ApplyActionResult execute({
    required GameState state,
    required PlayerId playerId,
  }) {
    final player = state.players[playerId];
    if (player == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final currentState = state;
    final steps = <GameStepEvent>[];

    for (final _ in player.hand) {
      //TODO(medium): Decay,Countdownの減算・条件判定処理を実行
    }

    return ApplyActionResult.success(state: currentState, steps: steps);
  }
}

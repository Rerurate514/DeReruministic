import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_card_states_service.g.dart';

@riverpod
ResolveCardStatesService resolveCardStatesService(Ref ref) {
  return ResolveCardStatesService();
}

class ResolveCardStatesService {
  ApplyActionResult execute({
    required GameState state,
    required PlayerId sourcePlayerId,
    required GameCard card,
  }) {
    final sourcePlayer = state.players[sourcePlayerId];

    if (sourcePlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newPlayerState = sourcePlayer.copyWith(
      pendingOverloadCost:
          sourcePlayer.pendingOverloadCost +
          card.definition.getOverloadCostAmount(),
    );

    final newState = state.copyWith(
      players: {...state.players, newPlayerState.id: newPlayerState},
    );

    return ApplyActionResult.success(state: newState, steps: []);
  }
}

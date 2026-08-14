import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consume_cost_service.g.dart';

@riverpod
ConsumeCostService consumeCostService(Ref ref) {
  return ConsumeCostService();
}

class ConsumeCostService {
  ApplyActionResult execute({
    required GameState state,
    required PlayerId sourcePlayerId,
    required GameCard card,
  }) {
    final cardUsedPlayer = state.players[sourcePlayerId];
    if (cardUsedPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newPlayerState = cardUsedPlayer.consumeCost(card.currentCost);

    return ApplyActionResult.success(
      state: state.copyWith(
        players: {...state.players, sourcePlayerId: newPlayerState},
      ),
      steps: [],
    );
  }
}

import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
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
    required GameCardInstanceId instanceId,
  }) {
    final cardUsedPlayer = state.players[sourcePlayerId];
    if (cardUsedPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final usedCard = state.findGameCardInZone(
      playerId: sourcePlayerId,
      instanceId: instanceId,
      zone: CardZone.playArea,
    );
    if (usedCard == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.cardNotFound,
      );
    }

    final newPlayerState = cardUsedPlayer.consumeCost(usedCard.currentCost);

    return ApplyActionResult.success(
      state: state.copyWith(
        players: {...state.players, sourcePlayerId: newPlayerState},
      ),
      steps: [],
    );
  }
}

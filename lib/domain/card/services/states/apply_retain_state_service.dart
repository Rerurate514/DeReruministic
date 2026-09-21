import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_retain_state_service.g.dart';

@riverpod
ApplyRetainStateService applyRetainStateService(Ref ref) {
  return ApplyRetainStateService();
}

class ApplyRetainStateService {
  ApplyActionResult execute(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final targetPlayer = state.players[playerId];
    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: .playerNotFound,
      );
    }

    final updatedPlayer = targetPlayer.copyWith(
      hand: targetPlayer.hand.map((card) {
        if (card.instanceId != instanceId) return card;

        return card.copyWith(
          currentCost: card.currentCost > 0 ? card.currentCost - 1 : 0,
        );
      }).toList(),
    );

    final newState = state.copyWith(
      players: {
        ...state.players,
        playerId: updatedPlayer,
      },
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [],
    );
  }
}

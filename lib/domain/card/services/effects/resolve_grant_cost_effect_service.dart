import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_grant_cost_effect_service.g.dart';

@riverpod
ResolveGrantCostEffectService resolveGrantCostEffectService(Ref ref) {
  return ResolveGrantCostEffectService();
}

class ResolveGrantCostEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectGrantCost effect,
    required PlayerId sourcePlayerId,
  }) {
    final sourcePlayer = state.players[sourcePlayerId];

    if (sourcePlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final targetPlayer = effect.target.getTargetPlayer(state, sourcePlayerId);

    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newCardTargetPlayer = targetPlayer.copyWith(
      currentCost: targetPlayer.currentCost + effect.amount,
    );

    final newState = state.copyWith(
      players: {...state.players, newCardTargetPlayer.id: newCardTargetPlayer},
    );

    final step = GameStepEvent.costCalculated(
      targetPlayerId: targetPlayer.id,
      amount: effect.amount,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

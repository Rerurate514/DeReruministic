import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_steal_cost_effect_service.g.dart';

@riverpod
ResolveStealCostEffectService resolveStealCostEffectService(Ref ref) {
  return ResolveStealCostEffectService();
}

class ResolveStealCostEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectStealCost effect,
    required PlayerId sourcePlayerId,
  }) {
    final sourcePlayer = state.players[sourcePlayerId];
    final targetPlayer = state.getOtherPlayer(sourcePlayerId);

    if (sourcePlayer == null || targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newTargetPlayer = targetPlayer.consumeCost(effect.amount);
    final actualStealedCost =
        targetPlayer.currentCost - newTargetPlayer.currentCost;

    final newSourcePlayer = sourcePlayer.updateCost(effect.amount);
    final actualGainedCost =
        newSourcePlayer.currentCost - sourcePlayer.currentCost;

    final stealedStep = GameStepEvent.costCalculated(
      targetPlayerId: targetPlayer.id,
      amount: -actualStealedCost,
    );

    final gainedStep = GameStepEvent.costCalculated(
      targetPlayerId: sourcePlayerId,
      amount: actualGainedCost,
    );

    final newState = state.copyWith(
      players: {
        ...state.players,
        targetPlayer.id: newTargetPlayer,
        sourcePlayerId: newSourcePlayer,
      },
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [stealedStep, gainedStep],
    );
  }
}

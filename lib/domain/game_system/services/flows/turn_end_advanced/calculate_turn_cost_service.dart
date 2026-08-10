import 'dart:math';

import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_turn_cost_service.g.dart';

@riverpod
CalculateTurnCostService calculateTurnCostService(Ref ref) {
  return CalculateTurnCostService();
}

class CalculateTurnCostService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final targetPlayerId = state.phase.turnOwner;
    final targetPlayer = state.players[targetPlayerId];

    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final initialCost = targetPlayer.currentCost;

    final newState = state
        .reflectBaseCost(targetPlayerId)
        .reflectCostBuff(targetPlayerId)
        .reflectCostDebuff(targetPlayerId)
        .reflectRecoilCost(targetPlayerId)
        .reflectClamp(targetPlayerId);

    final newTargetPlayer = newState.players[targetPlayerId];
    if (newTargetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final finalCost = newTargetPlayer.currentCost;
    final diff = finalCost - initialCost;

    final event = GameStepEvent.costCalculated(
      targetPlayerId: targetPlayerId,
      amount: diff,
    );

    return ApplyActionResult.success(state: newState, steps: [event]);
  }
}

extension GameStateEx on GameState {
  GameState reflectBaseCost(PlayerId targetPlayerId) {
    final targetPlayer = players[targetPlayerId];
    if (targetPlayer == null) return this;

    final updatedPlayer = targetPlayer.copyWith(
      currentCost:
          targetPlayer.currentCost + GameSystemConstants.baseTurnStartGainCost,
    );

    return copyWith(
      players: {
        ...players,
        targetPlayerId: updatedPlayer,
      },
    );
  }

  GameState reflectCostBuff(PlayerId targetPlayerId) {
    //TODO
    return this;
  }

  GameState reflectCostDebuff(PlayerId targetPlayerId) {
    //TODO
    return this;
  }

  GameState reflectRecoilCost(PlayerId targetPlayerId) {
    //TODO
    return this;
  }

  GameState reflectClamp(PlayerId targetPlayerId) {
    final targetPlayer = players[targetPlayerId];
    if (targetPlayer == null) return this;

    final currentCost = targetPlayer.currentCost;

    final updatedPlayer = targetPlayer.copyWith(
      currentCost: max(0, currentCost),
    );

    return copyWith(
      players: {
        ...players,
        targetPlayerId: updatedPlayer,
      },
    );
  }
}

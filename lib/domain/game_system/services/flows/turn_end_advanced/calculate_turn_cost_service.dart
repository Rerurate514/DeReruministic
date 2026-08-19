import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
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

    final resultCost =
        ((GameSystemConstants.baseTurnStartGainCost +
                    _calcCostBuff(targetPlayer)) -
                (_calcCostDebuff(targetPlayer) +
                    _calcRecoilCost(targetPlayer) +
                    _calcOverloadCost(targetPlayer)))
            .clamp(0, targetPlayer.maxCost);

    final newTargetPlayer = state.players[targetPlayerId]?.copyWith(
      currentCost: resultCost,
      pendingRecoilCost: 0,
      pendingOverloadCost: 0,
    );

    if (newTargetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newState = state.copyWith(
      players: {...state.players, newTargetPlayer.id: newTargetPlayer},
    );

    final finalCost = newTargetPlayer.currentCost;
    final diff = finalCost - initialCost;

    final event = GameStepEvent.costCalculated(
      targetPlayerId: targetPlayerId,
      amount: diff,
    );

    return ApplyActionResult.success(state: newState, steps: [event]);
  }

  int _calcCostBuff(PlayerState targetPlayer) {
    return targetPlayer.buffs
        .where((buffState) => buffState.buff == BuffTypes.costRecovery)
        .fold(0, (cost, buffState) => cost + buffState.stack);
  }

  int _calcCostDebuff(PlayerState targetPlayer) {
    return targetPlayer.debuffs
        .where((debuffState) => debuffState.debuff == DebuffTypes.costReduction)
        .fold(0, (cost, debuffState) => cost + debuffState.stack);
  }

  int _calcOverloadCost(PlayerState targetPlayer) {
    return targetPlayer.pendingOverloadCost;
  }

  int _calcRecoilCost(PlayerState targetPlayer) {
    return targetPlayer.pendingRecoilCost;
  }
}

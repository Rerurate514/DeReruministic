import 'dart:math';

import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_regen_service.g.dart';

@riverpod
ResolveRegenService resolveRegenService(Ref ref) => ResolveRegenService();

class ResolveRegenService implements TurnProcessStep {
  @override
  ApplyActionResult execute(GameState state) {
    final targetPlayer = state.currentTurnOwner;
    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }
    final regenAmount = targetPlayer.getBuffStack(BuffTypes.regeneration);
    final healedHp = min(targetPlayer.maxHp, targetPlayer.hp + regenAmount);
    final actualHealAmount = healedHp - targetPlayer.hp;
    final updatedPlayer = targetPlayer.copyWith(hp: healedHp);

    return ApplyActionResult.success(
      state: state.copyWith(
        players: {...state.players, updatedPlayer.id: updatedPlayer},
      ),
      steps: [
        GameStepEvent.regenApplied(
          targetPlayerId: updatedPlayer.id,
          amount: actualHealAmount,
        ),
      ],
    );
  }
}

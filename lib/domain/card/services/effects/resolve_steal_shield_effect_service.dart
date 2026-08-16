import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_steal_shield_effect_service.g.dart';

@riverpod
ResolveStealShieldEffectService resolveStealShieldEffectService(Ref ref) {
  return ResolveStealShieldEffectService();
}

class ResolveStealShieldEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectStealShield effect,
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

    final newTargetPlayer = targetPlayer.removeShield(effect.amount);
    final actualStealedShield = targetPlayer.shield - newTargetPlayer.shield;

    final newSourcePlayer = sourcePlayer.updateShield(actualStealedShield);
    final actualGainedShield = newSourcePlayer.shield - sourcePlayer.shield;

    final stealedStep = GameStepEvent.shieldRemoved(
      targetPlayerId: targetPlayer.id,
      amount: -actualStealedShield,
    );

    final gainedStep = GameStepEvent.shieldGained(
      targetPlayerId: sourcePlayerId,
      amount: actualGainedShield,
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

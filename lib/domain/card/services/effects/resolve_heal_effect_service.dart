import 'dart:math';

import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_heal_effect_service.g.dart';

@riverpod
ResolveHealEffectService resolveHealEffectService(Ref ref) {
  return ResolveHealEffectService();
}

class ResolveHealEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectHeal effect,
    required PlayerId sourcePlayerId,
  }) {
    final targetPlayerId = effect.target.getTargetPlayerId(
      state,
      sourcePlayerId,
    );
    final targetPlayer = state.players[targetPlayerId]!;

    final calculatedHp = targetPlayer.hp + effect.amount;
    final finalHp = min(targetPlayer.maxHp, calculatedHp);

    final newTargetPlayer = targetPlayer.copyWith(
      hp: finalHp,
    );

    final newState = state.copyWith(
      players: {...state.players, newTargetPlayer.id: newTargetPlayer},
    );

    final actualHealAmount = finalHp - targetPlayer.hp;

    final step = GameStepEvent.healed(
      targetPlayerId: newTargetPlayer.id,
      amount: actualHealAmount,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

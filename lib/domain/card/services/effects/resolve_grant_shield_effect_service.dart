import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_grant_shield_effect_service.g.dart';

@riverpod
ResolveGrantShieldEffectService resolveGrantShieldEffectService(Ref ref) {
  return ResolveGrantShieldEffectService();
}

//TODO(test): testの作成
class ResolveGrantShieldEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectGrantShield effect,
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
    final newCardTargetPlayer = targetPlayer.copyWith(
      shield: targetPlayer.shield + effect.amount,
    );

    final newState = state.copyWith(
      players: {...state.players, newCardTargetPlayer.id: newCardTargetPlayer},
    );

    final step = GameStepEvent.shieldGained(
      targetPlayerId: targetPlayer.id,
      amount: effect.amount,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

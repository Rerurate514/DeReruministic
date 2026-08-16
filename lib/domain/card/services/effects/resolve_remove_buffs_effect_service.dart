import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_remove_buffs_effect_service.g.dart';

@riverpod
ResolveRemoveBuffsEffectService resolveRemoveBuffsEffectService(Ref ref) {
  return ResolveRemoveBuffsEffectService();
}

class ResolveRemoveBuffsEffectService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectRemoveBuffs effect,
    required PlayerId sourcePlayerId,
  }) {
    final targetPlayerId = effect.target.getTargetPlayerId(
      state,
      sourcePlayerId,
    );
    final targetPlayer = state.players[targetPlayerId];

    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final newTargetPlayer = targetPlayer.copyWith(
      buffs: targetPlayer.buffs.removeBuffEffect(effect),
    );

    final newState = state.copyWith(
      players: {...state.players, newTargetPlayer.id: newTargetPlayer},
    );

    final step = GameStepEvent.buffRemoved(
      targetPlayerId: newTargetPlayer.id,
      buff: effect.buff,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

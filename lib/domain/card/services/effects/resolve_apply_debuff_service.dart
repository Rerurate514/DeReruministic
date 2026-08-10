import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_apply_debuff_service.g.dart';

@riverpod
ResolveApplyDebuffService resolveApplyDebuffService(Ref ref) {
  return ResolveApplyDebuffService();
}

class ResolveApplyDebuffService {
  ApplyActionResult execute({
    required GameState state,
    required CardEffectApplyDebuff effect,
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

    final newPlayerState = targetPlayer.applyDebuffState(
      effect.debuff,
      effect.stacks,
    );

    final newState = state.copyWith(
      players: {...state.players, newPlayerState.id: newPlayerState},
    );

    final step = GameStepEvent.debuffApplied(
      targetPlayerId: newPlayerState.id,
      debuff: effect.debuff,
      stack: effect.stacks,
      totalStack: newPlayerState.getDebuffStack(effect.debuff),
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

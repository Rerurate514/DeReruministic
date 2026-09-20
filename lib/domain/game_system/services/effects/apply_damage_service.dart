import 'dart:math';

import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/damage_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_damage_service.g.dart';

@riverpod
ApplyDamageService applyDamageService(Ref ref) {
  return ApplyDamageService();
}

class ApplyDamageService {
  ApplyActionResult execute({
    required GameState state,
    required PlayerId targetPlayerId,
    required int damage,
    required DamageTypes type,
  }) {
    final targetPlayer = state.players[targetPlayerId];

    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final shieldDamage = switch (type) {
      DamageTypes.normal => min(targetPlayer.shield, damage),
      DamageTypes.piercing => 0,
    };

    final hpDamage = switch (type) {
      DamageTypes.normal => damage - shieldDamage,
      DamageTypes.piercing => damage,
    };

    final newPlayer = targetPlayer.copyWith(
      shield: targetPlayer.shield - shieldDamage,
      hp: (targetPlayer.hp - hpDamage).clamp(0, targetPlayer.maxHp),
    );

    final newState = state
        .copyWith(
          players: {
            ...state.players,
            newPlayer.id: newPlayer,
          },
        )
        .pushTask(
          GameStateTaskPushPos.head,
          const .auto(
            .defeatCheck(),
          ),
        );

    return ApplyActionResult.success(
      state: newState,
      steps: [
        GameStepEvent.damageDealt(
          targetPlayerId: newPlayer.id,
          shieldDamage: shieldDamage,
          hpDamage: hpDamage,
        ),
      ],
    );
  }
}

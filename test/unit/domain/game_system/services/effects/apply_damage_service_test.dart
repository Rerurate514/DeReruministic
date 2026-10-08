import 'package:dereruministic/domain/game_system/services/effects/apply_damage_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/auto_game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/damage_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const attackerId = PlayerId(value: 'attacker');
  const defenderId = PlayerId(value: 'defender');

  test('reflectは攻撃者へ反射ダメージタスクを追加する', () {
    final state = buildState(
      players: {
        attackerId: buildPlayer(id: attackerId),
        defenderId: buildPlayer(
          id: defenderId,
          buffs: const [BuffState(buff: BuffTypes.reflect, stack: 3)],
        ),
      },
    );

    final result =
        ApplyDamageService().execute(
              state: state,
              targetPlayerId: defenderId,
              sourcePlayerId: attackerId,
              damage: 5,
              type: DamageTypes.normal,
            )
            as ApplyActionResultSuccess;

    expect(result.state.players[defenderId]!.hp, 15);
    final reflectTask = result.state.taskQueue.first as GameTaskAutoWrapper;
    expect(reflectTask.task, isA<AutoGameTaskApplyDamage>());
    expect(
      result.steps,
      [
        const GameStepEvent.damageDealt(
          targetPlayerId: defenderId,
          hpDamage: 5,
          shieldDamage: 0,
        ),
      ],
    );
  });
}

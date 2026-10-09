import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/auto_game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/damage_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const attackerId = PlayerId(value: 'attacker');
  const defenderId = PlayerId(value: 'defender');

  late ResolveDamageEffectService service;

  setUp(() {
    service = ResolveDamageEffectService();
  });

  group('ResolveDamageEffectService.execute', () {
    test('計算したダメージを適用タスクとして先頭に追加する', () {
      final state = buildState(
        players: {
          attackerId: buildPlayer(
            id: attackerId,
            buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 5)],
          ),
          defenderId: buildPlayer(id: defenderId),
        },
      );
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect((result as ApplyActionResultSuccess).steps, isEmpty);
      expect(result.state.players[defenderId]!.hp, 20);
      expect(result.state.taskQueue, [
        const GameTask.auto(
          AutoGameTask.applyDamage(
            targetPlayerId: defenderId,
            damage: 15,
            type: DamageTypes.normal,
            sourcePlayerId: attackerId,
          ),
        ),
      ]);
    });

    test('後続タスクを残したままダメージ適用タスクを追加する', () {
      const pendingTask = GameTask.auto(AutoGameTask.defeatCheck());
      final state = buildState(
        players: {
          attackerId: buildPlayer(id: attackerId),
          defenderId: buildPlayer(id: defenderId),
        },
      ).copyWith(taskQueue: QueueList.from([pendingTask]));
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect(result.state.taskQueue, [
        const GameTask.auto(
          AutoGameTask.applyDamage(
            targetPlayerId: defenderId,
            damage: 10,
            type: DamageTypes.normal,
            sourcePlayerId: attackerId,
          ),
        ),
        pendingTask,
      ]);
    });

    test('selfを対象にした場合は自分へのダメージ適用タスクを追加する', () {
      final state = buildState(
        players: {
          attackerId: buildPlayer(id: attackerId),
          defenderId: buildPlayer(id: defenderId),
        },
      );
      const effect = CardEffects.damage(
        amount: 5,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect(
        result.state.taskQueue.single,
        const GameTask.auto(
          AutoGameTask.applyDamage(
            targetPlayerId: attackerId,
            damage: 5,
            type: DamageTypes.normal,
            sourcePlayerId: attackerId,
          ),
        ),
      );
    });
  });
}

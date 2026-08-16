import 'package:dereruministic/domain/card/services/effects/resolve_remove_buffs_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const sourceId = PlayerId(value: 'source');
  const otherId = PlayerId(value: 'other');

  final service = ResolveRemoveBuffsEffectService();

  group('ResolveRemoveBuffsEffectService.execute', () {
    test('target=selfの場合、自分の指定buffのstackが減少する', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 5)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 2,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final buffs = success.state.players[sourceId]!.buffs;
      expect(buffs, hasLength(1));
      expect(buffs.single.buff, BuffTypes.atkBuff);
      expect(buffs.single.stack, 3); // 5 - 2
    });

    test('stackがちょうど0になる場合、そのbuffはリストから除去される', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 3)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 3,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.buffs, isEmpty);
    });

    test('stacksが現在のstackを上回る場合も、負にならずリストから除去される', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 2)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 10,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.buffs, isEmpty);
    });

    test('指定buff以外のbuffは影響を受けない', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [
          BuffState(buff: BuffTypes.atkBuff, stack: 4),
          BuffState(buff: BuffTypes.regeneration, stack: 2),
          BuffState(buff: BuffTypes.combo, stack: 1),
        ],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      final buffs = success.state.players[sourceId]!.buffs;
      expect(buffs, hasLength(3));
      expect(
        buffs.firstWhere((b) => b.buff == BuffTypes.atkBuff).stack,
        3, // 4 - 1
      );
      expect(
        buffs.firstWhere((b) => b.buff == BuffTypes.regeneration).stack,
        2, // 不変
      );
      expect(
        buffs.firstWhere((b) => b.buff == BuffTypes.combo).stack,
        1, // 不変
      );
    });

    test('対象が指定buffを持っていない場合、buffsは変化せず成功を返す', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.regeneration, stack: 2)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.buffs, hasLength(1));
      expect(
        success.state.players[sourceId]!.buffs.single.buff,
        BuffTypes.regeneration,
      );
    });

    test('buffsが空の場合も、空のまま成功を返す', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      expect(
        (result as ApplyActionResultSuccess).state.players[sourceId]!.buffs,
        isEmpty,
      );
    });

    test('target=enemyの場合、相手のbuffが除去され自分のbuffは変化しない', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 5)],
      );
      final other = buildPlayer(
        id: otherId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 4)],
      );
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 2,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[otherId]!.buffs.single.stack, 2); // 4 - 2
      expect(success.state.players[sourceId]!.buffs.single.stack, 5); // 不変
    });

    test('成功時、GameStepEvent.buffRemovedが正しい内容で1件返る', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(
        id: otherId,
        buffs: const [BuffState(buff: BuffTypes.guardBoost, stack: 3)],
      );
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.guardBoost,
        stacks: 1,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(1));
      final step = success.steps.single as GameStepEventBuffRemoved;
      expect(step.targetPlayerId, otherId);
      expect(step.buff, BuffTypes.guardBoost);
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 5)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeBuff(
        buff: BuffTypes.atkBuff,
        stacks: 2,
        target: CardTargetTypes.self,
      );

      service.execute(
        state: state,
        effect: effect as CardEffectRemoveBuffs,
        sourcePlayerId: sourceId,
      );

      expect(state.players[sourceId]!.buffs.single.stack, 5);
    });
  });
}

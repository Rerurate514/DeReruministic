import 'package:dereruministic/domain/card/services/effects/resolve_remove_debuffs_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const sourceId = PlayerId(value: 'source');
  const otherId = PlayerId(value: 'other');

  final service = ResolveRemoveDebuffsEffectService();

  group('ResolveRemoveDebuffsEffectService.execute', () {
    test('target=selfの場合、自分の指定debuffのstackが減少する', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 5)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 2,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final debuffs = success.state.players[sourceId]!.debuffs;
      expect(debuffs, hasLength(1));
      expect(debuffs.single.debuff, DebuffTypes.poison);
      expect(debuffs.single.stack, 3); // 5 - 2
    });

    test('stackがちょうど0になる場合、そのdebuffはリストから除去される', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 3)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 3,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.debuffs, isEmpty);
    });

    test('stacksが現在のstackを上回る場合も、負にならずリストから除去される', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.vulnerable, stack: 2)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.vulnerable,
        stacks: 10,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.debuffs, isEmpty);
    });

    test('指定debuff以外のdebuffは影響を受けない', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [
          DebuffState(debuff: DebuffTypes.poison, stack: 4),
          DebuffState(debuff: DebuffTypes.vulnerable, stack: 2),
          DebuffState(debuff: DebuffTypes.atkDebuff, stack: 1),
        ],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      final debuffs = success.state.players[sourceId]!.debuffs;
      expect(debuffs, hasLength(3));
      expect(
        debuffs.firstWhere((d) => d.debuff == DebuffTypes.poison).stack,
        3, // 4 - 1
      );
      expect(
        debuffs.firstWhere((d) => d.debuff == DebuffTypes.vulnerable).stack,
        2, // 不変
      );
      expect(
        debuffs.firstWhere((d) => d.debuff == DebuffTypes.atkDebuff).stack,
        1, // 不変
      );
    });

    test('対象が指定debuffを持っていない場合、debuffsは変化せず成功を返す', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.vulnerable, stack: 2)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.debuffs, hasLength(1));
      expect(
        success.state.players[sourceId]!.debuffs.single.debuff,
        DebuffTypes.vulnerable,
      );
    });

    test('debuffsが空の場合も、空のまま成功を返す', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      expect(
        (result as ApplyActionResultSuccess).state.players[sourceId]!.debuffs,
        isEmpty,
      );
    });

    test('target=enemyの場合、相手のdebuffが除去され自分のdebuffは変化しない', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 5)],
      );
      final other = buildPlayer(
        id: otherId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 4)],
      );
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 2,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[otherId]!.debuffs.single.stack, 2); // 4 - 2
      expect(success.state.players[sourceId]!.debuffs.single.stack, 5); // 不変
    });

    test('成功時、GameStepEvent.debuffRemovedが正しい内容で1件返る', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [
          DebuffState(debuff: DebuffTypes.costReduction, stack: 3),
        ],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.costReduction,
        stacks: 1,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(1));
      final step = success.steps.single as GameStepEventDebuffRemoved;
      expect(step.targetPlayerId, sourceId);
      expect(step.debuff, DebuffTypes.costReduction);
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 5)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.removeDebuff(
        debuff: DebuffTypes.poison,
        stacks: 2,
        target: CardTargetTypes.self,
      );

      service.execute(
        state: state,
        effect: effect as CardEffectRemoveDebuffs,
        sourcePlayerId: sourceId,
      );

      expect(state.players[sourceId]!.debuffs.single.stack, 5);
    });
  });
}

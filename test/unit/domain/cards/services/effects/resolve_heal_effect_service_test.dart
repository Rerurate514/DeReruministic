import 'package:dereruministic/domain/card/services/effects/resolve_heal_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const sourceId = PlayerId(value: 'source');
  const otherId = PlayerId(value: 'other');

  late ResolveHealEffectService service;

  setUp(() {
    service = ResolveHealEffectService();
  });

  group('ResolveHealEffectService.execute', () {
    test('maxHpに達しない場合、amount分HPが回復する', () {
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 5, target: CardTargetTypes.self);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      final updatedSource = result.state.players[sourceId]!;
      expect(updatedSource.hp, 15);
    });

    test('maxHpを超える回復量の場合、maxHpでクランプされる', () {
      final source = buildPlayer(id: sourceId, hp: 18);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 10, target: CardTargetTypes.self);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      final updatedSource = result.state.players[sourceId]!;
      expect(updatedSource.hp, 20);
    });

    test('target=selfの場合、自分自身が回復対象になる', () {
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId, hp: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 5, target: CardTargetTypes.self);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      final updatedSource = result.state.players[sourceId]!;
      final updatedOther = result.state.players[otherId]!;
      expect(updatedSource.hp, 15);
      expect(updatedOther.hp, 10);
    });

    test('target=enemyの場合、自分以外のプレイヤーが回復対象になる', () {
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId, hp: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 5, target: CardTargetTypes.enemy);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      final updatedSource = result.state.players[sourceId]!;
      final updatedOther = result.state.players[otherId]!;
      expect(updatedOther.hp, 15);
      expect(updatedSource.hp, 10);
    });

    test('既にmaxHpの場合、実際の回復量は0になる', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 5, target: CardTargetTypes.self);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      final updatedSource = result.state.players[sourceId]!;
      final step =
          (result as ApplyActionResultSuccess).steps.single
              as GameStepEventHealed;
      expect(updatedSource.hp, 20);
      expect(step.amount, 0);
    });

    test('GameStepEvent.healedが実際の回復量(クランプ後)で正しく1件返る', () {
      final source = buildPlayer(id: sourceId, hp: 18);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 10, target: CardTargetTypes.self);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      expect((result as ApplyActionResultSuccess).steps, hasLength(1));
      final step = result.steps.single as GameStepEventHealed;
      expect(step.targetPlayerId, sourceId);
      expect(step.amount, 2);
    });

    test('回復対象外のプレイヤーの状態はplayersマップ内で保持される', () {
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId, hp: 15);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 5, target: CardTargetTypes.self);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      expect(result.state.players[otherId], other);
      expect(result.state.players.length, 2);
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.heal(amount: 5, target: CardTargetTypes.self);

      service.execute(
        state: state,
        effect: effect as CardEffectHeal,
        sourcePlayerId: sourceId,
      );

      expect(state.players[sourceId]!.hp, 10);
    });
  });
}

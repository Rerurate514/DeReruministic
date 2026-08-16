import 'package:dereruministic/domain/card/services/effects/resolve_steal_shield_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const sourceId = PlayerId(value: 'source');
  const otherId = PlayerId(value: 'other');

  final service = ResolveStealShieldEffectService();

  group('ResolveStealShieldEffectService.execute', () {
    test('相手のシールドが減り、自分のシールドが同量増える', () {
      final source = buildPlayer(id: sourceId, shield: 1);
      final other = buildPlayer(id: otherId, shield: 5);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.shield, 4); // 1 + 3
      expect(success.state.players[otherId]!.shield, 2); // 5 - 3
    });

    test('相手のシールドが奪う量を下回る場合、相手は0でクランプされ自分は実際に奪えた分だけ増える', () {
      final source = buildPlayer(id: sourceId, shield: 0);
      final other = buildPlayer(id: otherId, shield: 2);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[otherId]!.shield, 0); // 負にならない
      // updateShieldにはeffect.amountではなくactualStealedShieldが渡されるため、
      // 存在しない分まで自分が得することはない
      expect(success.state.players[sourceId]!.shield, 2);
    });

    test('相手のシールドが0の場合、双方のシールドは変化せずstepのamountも0になる', () {
      final source = buildPlayer(id: sourceId, shield: 3);
      final other = buildPlayer(id: otherId, shield: 0);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.shield, 3);
      expect(success.state.players[otherId]!.shield, 0);
      expect((success.steps[0] as GameStepEventShieldRemoved).amount, 0);
      expect((success.steps[1] as GameStepEventShieldGained).amount, 0);
    });

    test('シールドに上限はないため、大量に奪っても自分側はクランプされない', () {
      final source = buildPlayer(id: sourceId, shield: 50);
      final other = buildPlayer(id: otherId, shield: 100);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 100);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.shield, 150); // 50 + 100
      expect(success.state.players[otherId]!.shield, 0);
    });

    test('amountが0の場合、双方のシールドは変化しない', () {
      final source = buildPlayer(id: sourceId, shield: 3);
      final other = buildPlayer(id: otherId, shield: 5);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 0);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.shield, 3);
      expect(success.state.players[otherId]!.shield, 5);
    });

    test('奪った量と奪われた量は常に一致する(シールドの総量が保存される)', () {
      final source = buildPlayer(id: sourceId, shield: 4);
      final other = buildPlayer(id: otherId, shield: 3);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 10);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      final totalBefore = source.shield + other.shield;
      final totalAfter =
          success.state.players[sourceId]!.shield +
          success.state.players[otherId]!.shield;
      expect(totalAfter, totalBefore); // 4 + 3 = 7
      expect(success.state.players[sourceId]!.shield, 7);
      expect(success.state.players[otherId]!.shield, 0);
    });

    test('sourcePlayerIdがstate.playersに存在しない場合、playerNotFoundで失敗し状態は変化しない', () {
      final other = buildPlayer(id: otherId, shield: 5);
      final state = buildState(players: {otherId: other});
      const effect = CardEffects.stealShield(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId, // playersに存在しない
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.playerNotFound);
      expect(failure.state, state);
    });

    test('相手プレイヤーが存在しない場合、playerNotFoundで失敗し状態は変化しない', () {
      final source = buildPlayer(id: sourceId, shield: 3);
      final state = buildState(players: {sourceId: source});
      const effect = CardEffects.stealShield(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.playerNotFound);
      expect(failure.state, state);
    });

    test('成功時、shieldRemoved(相手・負値)→shieldGained(自分・正値)の順で2件返る', () {
      final source = buildPlayer(id: sourceId, shield: 1);
      final other = buildPlayer(id: otherId, shield: 5);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(2));

      final stealedStep = success.steps[0] as GameStepEventShieldRemoved;
      expect(stealedStep.targetPlayerId, otherId);
      expect(stealedStep.amount, -3);

      final gainedStep = success.steps[1] as GameStepEventShieldGained;
      expect(gainedStep.targetPlayerId, sourceId);
      expect(gainedStep.amount, 3);
    });

    test('相手のシールドが不足する場合、stepのamountも実際に奪えた量になる', () {
      final source = buildPlayer(id: sourceId, shield: 0);
      final other = buildPlayer(id: otherId, shield: 2);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      final stealedStep = success.steps[0] as GameStepEventShieldRemoved;
      final gainedStep = success.steps[1] as GameStepEventShieldGained;
      expect(stealedStep.amount, -2); // effect.amount(5)ではなく実際の2
      expect(gainedStep.amount, 2);
    });

    test('HPやコストなど、シールド以外のフィールドには影響しない', () {
      final source = buildPlayer(
        id: sourceId,
        hp: 15,
        shield: 1,
        currentCost: 3,
      );
      final other = buildPlayer(
        id: otherId,
        hp: 18,
        shield: 5,
        currentCost: 2,
      );
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.hp, 15);
      expect(success.state.players[sourceId]!.currentCost, 3);
      expect(success.state.players[otherId]!.hp, 18);
      expect(success.state.players[otherId]!.currentCost, 2);
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final source = buildPlayer(id: sourceId, shield: 1);
      final other = buildPlayer(id: otherId, shield: 5);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealShield(amount: 3);

      service.execute(
        state: state,
        effect: effect as CardEffectStealShield,
        sourcePlayerId: sourceId,
      );

      expect(state.players[sourceId]!.shield, 1);
      expect(state.players[otherId]!.shield, 5);
    });
  });
}

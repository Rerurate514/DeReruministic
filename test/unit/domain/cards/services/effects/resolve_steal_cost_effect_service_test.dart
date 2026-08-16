import 'package:dereruministic/domain/card/services/effects/resolve_steal_cost_effect_service.dart';
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

  final service = ResolveStealCostEffectService();

  group('ResolveStealCostEffectService.execute', () {
    test('相手のコストが減り、自分のコストが同量増える', () {
      final source = buildPlayer(id: sourceId, currentCost: 1, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 5, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.currentCost, 4); // 1 + 3
      expect(success.state.players[otherId]!.currentCost, 2); // 5 - 3
    });

    test('相手のコストが奪う量を下回る場合、相手は0でクランプされる', () {
      final source = buildPlayer(id: sourceId, currentCost: 0, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 2, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[otherId]!.currentCost, 0); // 負にならない
      // 奪った側は相手の残量に関わらずeffect.amount分加算される(クランプ内で)
      expect(success.state.players[sourceId]!.currentCost, 5);
    });

    test('自分のコストがmaxCostを超える場合、maxCostでクランプされる', () {
      final source = buildPlayer(id: sourceId, currentCost: 8, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 9, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.currentCost, 10); // 8+5 -> 10
      expect(success.state.players[otherId]!.currentCost, 4); // 9-5
    });

    test('amountが0の場合、双方のコストは変化せずstepのamountも0になる', () {
      final source = buildPlayer(id: sourceId, currentCost: 3, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 5, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 0);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.currentCost, 3);
      expect(success.state.players[otherId]!.currentCost, 5);
      expect((success.steps[0] as GameStepEventCostCalculated).amount, 0);
      expect((success.steps[1] as GameStepEventCostCalculated).amount, 0);
    });

    test('sourcePlayerIdがstate.playersに存在しない場合、playerNotFoundで失敗し状態は変化しない', () {
      final other = buildPlayer(id: otherId, currentCost: 5, maxCost: 10);
      final state = buildState(players: {otherId: other});
      const effect = CardEffects.stealCost(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId, // playersに存在しない
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.playerNotFound);
      expect(failure.state, state);
    });

    test('相手プレイヤーが存在しない場合、playerNotFoundで失敗し状態は変化しない', () {
      final source = buildPlayer(id: sourceId, currentCost: 3, maxCost: 10);
      final state = buildState(players: {sourceId: source});
      const effect = CardEffects.stealCost(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.playerNotFound);
      expect(failure.state, state);
    });

    test('成功時、costCalculatedのstepが「相手側(負値)→自分側(正値)」の順で2件返る', () {
      final source = buildPlayer(id: sourceId, currentCost: 1, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 5, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 3);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(2));

      final stealedStep = success.steps[0] as GameStepEventCostCalculated;
      expect(stealedStep.targetPlayerId, otherId);
      expect(stealedStep.amount, -3);

      final gainedStep = success.steps[1] as GameStepEventCostCalculated;
      expect(gainedStep.targetPlayerId, sourceId);
      expect(gainedStep.amount, 3); // 奪った側は正の値
    });

    test('相手のコストが不足する場合、stepのamountも実際に奪えた量になる', () {
      // 相手は2しか持っていないので、実際に奪えるのは2
      final source = buildPlayer(id: sourceId, currentCost: 0, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 2, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      final stealedStep = success.steps[0] as GameStepEventCostCalculated;
      expect(stealedStep.amount, -2); // effect.amount(5)ではなく実際の2
    });

    test('自分のコストがmaxCostで頭打ちの場合、stepのamountも実際に増えた量になる', () {
      // 自分はmaxCost(10)まであと1しか増やせない
      final source = buildPlayer(id: sourceId, currentCost: 9, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 9, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 5);

      final result = service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.currentCost, 10); // +1のみ
      expect(success.state.players[otherId]!.currentCost, 4); // -5

      final stealedStep = success.steps[0] as GameStepEventCostCalculated;
      final gainedStep = success.steps[1] as GameStepEventCostCalculated;
      expect(stealedStep.amount, -5); // 相手は満額奪われる
      expect(gainedStep.amount, 1); // 自分は1しか増えない
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final source = buildPlayer(id: sourceId, currentCost: 1, maxCost: 10);
      final other = buildPlayer(id: otherId, currentCost: 5, maxCost: 10);
      final state = buildState(players: {sourceId: source, otherId: other});
      const effect = CardEffects.stealCost(amount: 3);

      service.execute(
        state: state,
        effect: effect as CardEffectStealCost,
        sourcePlayerId: sourceId,
      );

      expect(state.players[sourceId]!.currentCost, 1);
      expect(state.players[otherId]!.currentCost, 5);
    });
  });
}

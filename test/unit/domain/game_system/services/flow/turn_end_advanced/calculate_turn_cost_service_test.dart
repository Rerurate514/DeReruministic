import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/game_test_helpers.dart';

void main() {
  late CalculateTurnCostService calculateTurnCostService;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');

  setUp(() {
    calculateTurnCostService = CalculateTurnCostService();
  });

  group('CalculateTurnCostService', () {
    test('ターン所有者のコストを基礎回復量と増減効果から計算し、予約コストをクリアする', () {
      final playerAState = buildPlayer(
        id: playerAId,
        currentCost: 2,
        maxCost: 10,
        buffs: const [
          BuffState(buff: BuffTypes.costRecovery, stack: 3),
          BuffState(buff: BuffTypes.atkBuff, stack: 99),
        ],
        debuffs: const [
          DebuffState(debuff: DebuffTypes.costReduction, stack: 2),
          DebuffState(debuff: DebuffTypes.atkDebuff, stack: 99),
        ],
        pendingRecoilCost: 1,
      ).copyWith(pendingOverloadCost: 2);

      final playerBState = buildPlayer(
        id: playerBId,
        currentCost: 1,
        maxCost: 10,
      ).copyWith(pendingOverloadCost: 4);

      final state = buildState(
        players: {
          playerAId: playerAState,
          playerBId: playerBState,
        },
        turnOwner: playerAId,
      );

      final result =
          calculateTurnCostService.execute(state) as ApplyActionResultSuccess;

      final statePlayerA = result.state.players[playerAId]!;
      final statePlayerB = result.state.players[playerBId]!;

      expect(statePlayerA.currentCost, equals(2));
      expect(statePlayerA.pendingRecoilCost, equals(0));
      expect(statePlayerA.pendingOverloadCost, equals(0));

      expect(statePlayerB.currentCost, equals(1));
      expect(statePlayerB.pendingOverloadCost, equals(4));

      expect(result.steps.length, equals(1));
      final step = result.steps.first as GameStepEventCostCalculated;
      expect(step.targetPlayerId, equals(playerAId));
      expect(step.amount, equals(0));
    });

    test('計算後のコストが最大コストを超える場合は最大コストに丸められる', () {
      final playerAState = buildPlayer(
        id: playerAId,
        currentCost: 3,
        maxCost: 5,
        buffs: const [
          BuffState(buff: BuffTypes.costRecovery, stack: 10),
        ],
      );

      final state = buildState(players: {playerAId: playerAState});

      final result =
          calculateTurnCostService.execute(state) as ApplyActionResultSuccess;

      final statePlayerA = result.state.players[playerAId]!;
      expect(statePlayerA.currentCost, equals(5));

      final step = result.steps.first as GameStepEventCostCalculated;
      expect(step.amount, equals(2));
    });

    test('計算後のコストが0未満になる場合は0に丸められる', () {
      final playerAState = buildPlayer(
        id: playerAId,
        currentCost: 3,
        maxCost: 10,
        debuffs: const [
          DebuffState(debuff: DebuffTypes.costReduction, stack: 7),
        ],
        pendingRecoilCost: 3,
      ).copyWith(pendingOverloadCost: 2);

      final state = buildState(players: {playerAId: playerAState});

      final result =
          calculateTurnCostService.execute(state) as ApplyActionResultSuccess;

      final statePlayerA = result.state.players[playerAId]!;
      expect(statePlayerA.currentCost, equals(0));
      expect(statePlayerA.pendingRecoilCost, equals(0));
      expect(statePlayerA.pendingOverloadCost, equals(0));

      final step = result.steps.first as GameStepEventCostCalculated;
      expect(step.amount, equals(-3));
    });

    test('ターン所有者が存在しない場合はplayerNotFoundで失敗する', () {
      final playerAState = buildPlayer(id: playerAId);
      final missingPlayerState =
          buildState(
            players: {playerAId: playerAState},
          ).copyWith(
            phase: buildState(
              players: {playerBId: buildPlayer(id: playerBId)},
            ).phase,
          );

      final result =
          calculateTurnCostService.execute(missingPlayerState)
              as ApplyActionResultFailure;

      expect(result.state, equals(missingPlayerState));
      expect(result.reason, equals(ActionFailureReason.playerNotFound));
    });
  });
}

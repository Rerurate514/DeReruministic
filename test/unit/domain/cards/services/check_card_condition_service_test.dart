import 'package:dereruministic/domain/card/services/conditions/check_target_has_buff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_debuff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_percentage_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_value_condition_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';

PlayerState buildPlayer({
  required PlayerId id,
  int hp = 20,
  int maxHp = 20,
  List<BuffState> buffs = const [],
  List<DebuffState> debuffs = const [],
}) {
  return PlayerState(
    id: id,
    hp: hp,
    maxHp: maxHp,
    shield: 0,
    currentCost: 0,
    maxCost: 4,
    deck: const [],
    hand: const [],
    graveyard: const [],
    exhausted: const [],
    buffs: buffs,
    debuffs: debuffs,
    cardsPlayedThisTurn: 0,
    maxHandSize: 5,
    pendingRecoilCost: 0,
    pendingOverloadCost: 0,
  );
}

GameState buildState({
  required PlayerState playerA,
  required PlayerState playerB,
}) {
  return GameState(
    players: {playerA.id: playerA, playerB.id: playerB},
    phase: GamePhase.init(playerA.id),
    turnCount: 0,
    initialTurnOwner: playerA.id,
    metadata: const SystemMetadata(seed: 0, actionSequenceNumber: 1),
  );
}

void main() {
  const sourceId = PlayerId(value: 'source');
  const otherId = PlayerId(value: 'other');

  group('CheckTargetHasBuffConditionService.execute', () {
    final service = CheckTargetHasBuffConditionService();

    test('対象(self)が指定buffを持っている場合、trueを返す', () {
      final source = buildPlayer(
        id: sourceId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 1)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHasBuffCondition(
                target: CardTargetTypes.self,
                buff: BuffTypes.atkBuff,
              )
              as EffectConditionTargetHasBuffCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });

    test('対象(self)が指定buffを持っていない場合、falseを返す', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHasBuffCondition(
                target: CardTargetTypes.self,
                buff: BuffTypes.atkBuff,
              )
              as EffectConditionTargetHasBuffCondition;

      final result = service.execute(state, condition, source);

      expect(result, isFalse);
    });

    test('target=enemyの場合、相手プレイヤーのbuffが判定される', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(
        id: otherId,
        buffs: const [BuffState(buff: BuffTypes.combo, stack: 1)],
      );
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHasBuffCondition(
                target: CardTargetTypes.enemy,
                buff: BuffTypes.combo,
              )
              as EffectConditionTargetHasBuffCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });
  });

  group('CheckTargetHasDebuffConditionService.execute', () {
    final service = CheckTargetHasDebuffConditionService();

    test('対象(self)が指定debuffを持っている場合、trueを返す', () {
      final source = buildPlayer(
        id: sourceId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 1)],
      );
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHasDebuffCondition(
                target: CardTargetTypes.self,
                debuff: DebuffTypes.poison,
              )
              as EffectConditionTargetHasDebuffCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });

    test('対象(self)が指定debuffを持っていない場合、falseを返す', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHasDebuffCondition(
                target: CardTargetTypes.self,
                debuff: DebuffTypes.poison,
              )
              as EffectConditionTargetHasDebuffCondition;

      final result = service.execute(state, condition, source);

      expect(result, isFalse);
    });

    test('target=enemyの場合、相手プレイヤーのdebuffが判定される', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(
        id: otherId,
        debuffs: const [DebuffState(debuff: DebuffTypes.vulnerable, stack: 1)],
      );
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHasDebuffCondition(
                target: CardTargetTypes.enemy,
                debuff: DebuffTypes.vulnerable,
              )
              as EffectConditionTargetHasDebuffCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });
  });

  group('CheckTargetHpPercentageConditionService.execute', () {
    final service = CheckTargetHpPercentageConditionService();

    test('HP割合がちょうどpercentageと等しい場合、equalでtrueを返す', () {
      // hp=10, maxHp=20 -> 50%
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpPercentageCondition(
                target: CardTargetTypes.self,
                percentage: 50,
                operator: ComparisonOperator.equal,
              )
              as EffectConditionTargetHpPercentageCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });

    test('HP割合がpercentage未満の場合、lessThanでtrueを返す', () {
      // hp=10, maxHp=20 -> 50% < 70%
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpPercentageCondition(
                target: CardTargetTypes.self,
                percentage: 70,
                operator: ComparisonOperator.lessThan,
              )
              as EffectConditionTargetHpPercentageCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });

    test('HP割合がpercentage以上の条件を満たさない場合、falseを返す', () {
      // hp=10, maxHp=20 -> 50% >= 80% は false
      final source = buildPlayer(id: sourceId, hp: 10);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpPercentageCondition(
                target: CardTargetTypes.self,
                percentage: 80,
                operator: ComparisonOperator.greaterOrEqual,
              )
              as EffectConditionTargetHpPercentageCondition;

      final result = service.execute(state, condition, source);

      expect(result, isFalse);
    });

    test('target=enemyの場合、相手プレイヤーのHP割合が判定される', () {
      // other: hp=15, maxHp=20 -> 75% > 50%
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId, hp: 15);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpPercentageCondition(
                target: CardTargetTypes.enemy,
                percentage: 50,
                operator: ComparisonOperator.greaterThan,
              )
              as EffectConditionTargetHpPercentageCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });
  });

  group('CheckTargetHpValueConditionService.execute', () {
    final service = CheckTargetHpValueConditionService();

    test('HP値がvalueより大きい場合、greaterThanでtrueを返す', () {
      final source = buildPlayer(id: sourceId, hp: 15);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpValueCondition(
                target: CardTargetTypes.self,
                value: 10,
                operator: ComparisonOperator.greaterThan,
              )
              as EffectConditionTargetHpValueCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });

    test('HP値がvalueを満たさない場合、falseを返す', () {
      final source = buildPlayer(id: sourceId, hp: 15);
      final other = buildPlayer(id: otherId);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpValueCondition(
                target: CardTargetTypes.self,
                value: 20,
                operator: ComparisonOperator.greaterThan,
              )
              as EffectConditionTargetHpValueCondition;

      final result = service.execute(state, condition, source);

      expect(result, isFalse);
    });

    test('target=enemyの場合、相手プレイヤーのHP値が判定される', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId, hp: 5);
      final state = buildState(playerA: source, playerB: other);
      const condition =
          EffectConditions.targetHpValueCondition(
                target: CardTargetTypes.enemy,
                value: 10,
                operator: ComparisonOperator.lessOrEqual,
              )
              as EffectConditionTargetHpValueCondition;

      final result = service.execute(state, condition, source);

      expect(result, isTrue);
    });
  });
}

import 'package:dereruministic/domain/card/services/calculators/damage_calculator.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const attackerId = PlayerId(value: 'attacker');
  const defenderId = PlayerId(value: 'defender');

  group('DamageCalculator.execute', () {
    test('修正なしの場合、baseDamageがそのまま返る', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 10);
    });

    test('攻撃側のatkBuffで与ダメージが増加する', () {
      final attacker = buildPlayer(
        id: attackerId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 3)],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 13);
    });

    test('攻撃側のcomboで与ダメージが増加する', () {
      final attacker = buildPlayer(
        id: attackerId,
        buffs: const [BuffState(buff: BuffTypes.combo, stack: 2)],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 12);
    });

    test('攻撃側のダメージ非修正buff(例: regeneration)は無視される', () {
      final attacker = buildPlayer(
        id: attackerId,
        buffs: const [BuffState(buff: BuffTypes.regeneration, stack: 5)],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 10);
    });

    test('攻撃側のatkDebuffで与ダメージが減少する', () {
      final attacker = buildPlayer(
        id: attackerId,
        debuffs: const [DebuffState(debuff: DebuffTypes.atkDebuff, stack: 4)],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 6);
    });

    test('攻撃側のダメージ非修正debuff(例: poison)は無視される', () {
      final attacker = buildPlayer(
        id: attackerId,
        debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 5)],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 10);
    });

    test('防御側のvulnerableで被ダメージが増加する', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(
        id: defenderId,
        debuffs: const [DebuffState(debuff: DebuffTypes.vulnerable, stack: 3)],
      );

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 13);
    });

    test('防御側のダメージ非修正buff(guardBoostなど)は無視される', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(
        id: defenderId,
        buffs: const [BuffState(buff: BuffTypes.guardBoost, stack: 5)],
      );

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 10);
    });

    test('複数の修正が組み合わさった場合、順番通りに適用される', () {
      // attacker: atkBuff(+3) -> atkDebuff(-4)
      // defender: vulnerable(+2)
      // base=10 -> +3=13 -> -4=9 -> +2=11
      final attacker = buildPlayer(
        id: attackerId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 3)],
        debuffs: const [DebuffState(debuff: DebuffTypes.atkDebuff, stack: 4)],
      );
      final defender = buildPlayer(
        id: defenderId,
        debuffs: const [DebuffState(debuff: DebuffTypes.vulnerable, stack: 2)],
      );

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 11);
    });

    test('計算結果が負になる場合は0でクランプされる', () {
      final attacker = buildPlayer(
        id: attackerId,
        debuffs: const [
          DebuffState(debuff: DebuffTypes.atkDebuff, stack: 100),
        ],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 0);
    });

    test('baseDamageが0でvulnerableのみの場合、加算されて0を超える', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(
        id: defenderId,
        debuffs: const [DebuffState(debuff: DebuffTypes.vulnerable, stack: 5)],
      );

      final result = DamageCalculator.execute(
        baseDamage: 0,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 5);
    });

    test('同一プレイヤーに複数スタックの同種buffがある場合、それぞれ加算される', () {
      final attacker = buildPlayer(
        id: attackerId,
        buffs: const [
          BuffState(buff: BuffTypes.atkBuff, stack: 2),
          BuffState(buff: BuffTypes.combo, stack: 3),
        ],
      );
      final defender = buildPlayer(id: defenderId);

      final result = DamageCalculator.execute(
        baseDamage: 10,
        attacker: attacker,
        defender: defender,
      );

      expect(result, 15);
    });
  });
}

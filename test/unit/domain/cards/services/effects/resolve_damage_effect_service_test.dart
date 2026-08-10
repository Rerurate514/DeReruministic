import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
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
  int shield = 0,
  List<BuffState> buffs = const [],
  List<DebuffState> debuffs = const [],
}) {
  return PlayerState(
    id: id,
    hp: hp,
    maxHp: maxHp,
    shield: shield,
    currentCost: 0,
    deck: const [],
    hand: const [],
    graveyard: const [],
    exhausted: const [],
    buffs: buffs,
    debuffs: debuffs,
    cardsPlayedThisTurn: 0,
    maxHandSize: 5,
    pendingRecoilCost: 0,
  );
}

GameState buildState({
  required PlayerState playerA,
  required PlayerState playerB,
  PlayerId? turnOwner,
}) {
  return GameState(
    seed: 0,
    players: {
      playerA.id: playerA,
      playerB.id: playerB,
    },
    phase: GamePhase.init(turnOwner ?? playerA.id),
    turnCount: 0,
  );
}

void main() {
  const attackerId = PlayerId(value: 'attacker');
  const defenderId = PlayerId(value: 'defender');

  late ResolveDamageEffectService service;

  setUp(() {
    service = ResolveDamageEffectService();
  });

  group('ResolveDamageEffectService.execute', () {
    test('シールドがない場合、ダメージは全てHPに入る', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedDefender = result.state.players[defenderId]!;
      expect(updatedDefender.hp, 10);
      expect(updatedDefender.shield, 0);
    });

    test('シールドが十分にある場合、ダメージは全てシールドに吸収される', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId, shield: 15);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedDefender = result.state.players[defenderId]!;
      expect(updatedDefender.hp, 20);
      expect(updatedDefender.shield, 5);
    });

    test('シールドが一部しかない場合、シールドを使い切った上でHPが減る', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId, shield: 4);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedDefender = result.state.players[defenderId]!;
      expect(updatedDefender.shield, 0);
      expect(updatedDefender.hp, 14); // 20 - (10 - 4)
    });

    test('targetPlayerIdがnullかつtarget=enemyの場合、自分以外のプレイヤーが対象になる', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 7,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedDefender = result.state.players[defenderId]!;
      final updatedAttacker = result.state.players[attackerId]!;
      expect(updatedDefender.hp, 13);
      expect(updatedAttacker.hp, 20); // 攻撃側は変化しない
    });

    test('targetPlayerIdがnullかつtarget=selfの場合、自分自身が対象になる', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 5,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedAttacker = result.state.players[attackerId]!;
      final updatedDefender = result.state.players[defenderId]!;
      expect(updatedAttacker.hp, 15);
      expect(updatedDefender.hp, 20); // 対象外プレイヤーは変化しない
    });

    test('DamageCalculatorのbuff/debuff補正が適用された上でシールド/HPが計算される', () {
      final attacker = buildPlayer(
        id: attackerId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 5)],
      );
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedDefender = result.state.players[defenderId]!;
      expect(updatedDefender.hp, 5); // 20 - (10 + 5)
    });

    test('計算後ダメージが0の場合、HP・シールドともに変化しない', () {
      final attacker = buildPlayer(
        id: attackerId,
        debuffs: const [DebuffState(debuff: DebuffTypes.atkDebuff, stack: 100)],
      );
      final defender = buildPlayer(id: defenderId, shield: 3);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      final updatedDefender = result.state.players[defenderId]!;
      expect(updatedDefender.hp, 20);
      expect(updatedDefender.shield, 3);
    });

    test('GameStepEvent.damageDealtが正しい内容で1件返る', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId, shield: 4);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect((result as ApplyActionResultSuccess).steps, hasLength(1));
      final step = result.steps.single as GameStepEventDamageDealt;
      expect(step.targetPlayerId, defenderId);
      expect(step.shieldDamage, 4);
      expect(step.hpDamage, 6);
    });

    test('攻撃側プレイヤーの状態はplayersマップ内で保持される', () {
      final attacker = buildPlayer(id: attackerId, hp: 18);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 5,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect(result.state.players[attackerId], attacker);
      expect(result.state.players.length, 2);
    });

    test('HPを超えた攻撃をしたとき、相手のHPは0でクランプされる。(シールド無し)', () {
      final attacker = buildPlayer(id: attackerId, hp: 1);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 99,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect(result.state.players[defenderId]!.hp, 0);
    });

    test('HPを超えた攻撃をしたとき、相手のHPは0でクランプされる。(シールド有り)', () {
      final attacker = buildPlayer(id: attackerId, hp: 50, shield: 50);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 999,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect(result.state.players[defenderId]!.hp, 0);
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final attacker = buildPlayer(id: attackerId);
      final defender = buildPlayer(id: defenderId);
      final state = buildState(playerA: attacker, playerB: defender);
      const effect = CardEffects.damage(
        amount: 10,
        target: CardTargetTypes.enemy,
      );

      service.execute(
        state: state,
        effect: effect as CardEffectDamage,
        sourcePlayerId: attackerId,
      );

      expect(state.players[defenderId]!.hp, 20);
    });
  });
}

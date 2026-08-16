import 'package:dereruministic/domain/card/services/effects/resolve_grant_shield_effect_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';

PlayerState buildPlayer({required PlayerId id, int shield = 0}) {
  return PlayerState(
    id: id,
    hp: 20,
    maxHp: 20,
    shield: shield,
    currentCost: 3,
    maxCost: 4,
    deck: const [],
    hand: const [],
    graveyard: const [],
    exhausted: const [],
    buffs: const [],
    debuffs: const [],
    cardsPlayedThisTurn: 0,
    maxHandSize: 5,
    pendingRecoilCost: 0,
  );
}

GameState buildState({
  required Map<PlayerId, PlayerState> players,
  required PlayerId turnOwner,
}) {
  return GameState(
    seed: 0,
    players: players,
    phase: GamePhase(battlePhase: BattlePhase.mainPhase, turnOwner: turnOwner),
    turnCount: 0,
    initialTurnOwner: turnOwner,
  );
}

void main() {
  const sourceId = PlayerId(value: 'source');
  const otherId = PlayerId(value: 'other');

  final service = ResolveGrantShieldEffectService();

  group('ResolveGrantShieldEffectService.execute', () {
    test('sourcePlayerIdがstate.playersに存在しない場合、playerNotFoundで失敗し状態は変化しない', () {
      final state = buildState(
        players: {sourceId: buildPlayer(id: sourceId)},
        turnOwner: sourceId,
      );
      const effect = CardEffects.grantShield(
        amount: 5,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectGrantShield,
        sourcePlayerId: otherId, // playersに存在しない
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.playerNotFound);
      expect(failure.state, state);
    });

    test('target=selfの場合、自分自身のshieldが増加する', () {
      final source = buildPlayer(id: sourceId, shield: 2);
      final other = buildPlayer(id: otherId, shield: 1);
      final state = buildState(
        players: {sourceId: source, otherId: other},
        turnOwner: sourceId,
      );
      const effect = CardEffects.grantShield(
        amount: 5,
        target: CardTargetTypes.self,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectGrantShield,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourceId]!.shield, 7); // 2 + 5
      expect(success.state.players[otherId]!.shield, 1); // 対象外は不変
    });

    test('target=enemyの場合、相手のshieldが増加する', () {
      final source = buildPlayer(id: sourceId, shield: 0);
      final other = buildPlayer(id: otherId, shield: 3);
      final state = buildState(
        players: {sourceId: source, otherId: other},
        turnOwner: sourceId,
      );
      const effect = CardEffects.grantShield(
        amount: 4,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectGrantShield,
        sourcePlayerId: sourceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[otherId]!.shield, 7); // 3 + 4
      expect(success.state.players[sourceId]!.shield, 0); // 対象外は不変
    });

    test('成功時、GameStepEvent.shieldGainedが正しい内容で1件返る', () {
      final source = buildPlayer(id: sourceId);
      final other = buildPlayer(id: otherId, shield: 1);
      final state = buildState(
        players: {sourceId: source, otherId: other},
        turnOwner: sourceId,
      );
      const effect = CardEffects.grantShield(
        amount: 4,
        target: CardTargetTypes.enemy,
      );

      final result = service.execute(
        state: state,
        effect: effect as CardEffectGrantShield,
        sourcePlayerId: sourceId,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(1));
      final step = success.steps.single as GameStepEventShieldGained;
      expect(step.targetPlayerId, otherId);
      expect(step.amount, 4);
    });

    test('元のGameStateは変更されない(イミュータブル)', () {
      final source = buildPlayer(id: sourceId, shield: 0);
      final other = buildPlayer(id: otherId);
      final state = buildState(
        players: {sourceId: source, otherId: other},
        turnOwner: sourceId,
      );
      const effect = CardEffects.grantShield(
        amount: 3,
        target: CardTargetTypes.self,
      );

      service.execute(
        state: state,
        effect: effect as CardEffectGrantShield,
        sourcePlayerId: sourceId,
      );

      expect(state.players[sourceId]!.shield, 0);
    });

    test(
      'targetPlayerId解決不能時に想定されているplayerNotFound分岐は、'
      '現行のgetTargetPlayerId(firstWhereでの例外送出)実装では通常到達できず、'
      'プレイヤーが1人しかいない状態でenemyを指定すると代わりに例外が送出される',
      () {
        final source = buildPlayer(id: sourceId);
        final state = buildState(
          players: {sourceId: source}, // 相手プレイヤーが存在しない
          turnOwner: sourceId,
        );
        const effect = CardEffects.grantShield(
          amount: 3,
          target: CardTargetTypes.enemy,
        );

        expect(
          () => service.execute(
            state: state,
            effect: effect as CardEffectGrantShield,
            sourcePlayerId: sourceId,
          ),
          throwsStateError,
        );
      },
    );
  });
}

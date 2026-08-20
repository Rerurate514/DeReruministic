import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/validation_result.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/game_test_helpers.dart';

const cardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def_1'),
  name: 'Strike',
  baseCost: 1,
  effects: [],
  states: [],
);

void main() {
  const playerId = PlayerId(value: 'player1');
  const otherPlayerId = PlayerId(value: 'player2');

  final validator = PlayCardValidator();

  group('PlayCardValidator.validate', () {
    test('全ての条件を満たす場合、成功を返す', () {
      final card = buildCard(instanceId: 'card1', currentCost: 2);
      final player = buildPlayer(id: playerId, hand: [card]);
      final other = buildPlayer(id: otherPlayerId);
      final state = buildState(
        players: {playerId: player, otherPlayerId: other},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(result, const ValidationResultSuccess());
    });

    test('コストがちょうど足りる場合(境界値)、成功を返す', () {
      final card = buildCard(instanceId: 'card1', currentCost: 3);
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(result, const ValidationResultSuccess());
    });

    test('mainPhaseでない場合、invalidPhaseで失敗する', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        battlePhase: BattlePhase.turnStart,
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(
        result,
        const ValidationResultFailure(
          reason: ActionFailureReason.invalidPhase,
        ),
      );
    });

    test('mainPhaseだが自分の手番でない場合、invalidPhaseで失敗する', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final other = buildPlayer(id: otherPlayerId);
      final state = buildState(
        players: {playerId: player, otherPlayerId: other},
        turnOwner: otherPlayerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(
        result,
        const ValidationResultFailure(
          reason: ActionFailureReason.invalidPhase,
        ),
      );
    });

    test('mainPhaseでもなく自分の手番でもない場合、invalidPhaseで失敗する', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final other = buildPlayer(id: otherPlayerId);
      final state = buildState(
        players: {playerId: player, otherPlayerId: other},
        battlePhase: BattlePhase.turnStart,
        turnOwner: otherPlayerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(
        result,
        const ValidationResultFailure(
          reason: ActionFailureReason.invalidPhase,
        ),
      );
    });

    test('action.playerIdがstate.playersに存在しない場合、playerNotFoundで失敗する', () {
      final state = buildState(
        players: {playerId: buildPlayer(id: playerId)},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: otherPlayerId, // playersマップに存在しない
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(
        result,
        const ValidationResultFailure(
          reason: ActionFailureReason.playerNotFound,
        ),
      );
    });

    test('指定したcardInstanceIdが手札にない場合、cardNotFoundで失敗する', () {
      final player = buildPlayer(id: playerId);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'not_in_hand',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(
        result,
        const ValidationResultFailure(
          reason: ActionFailureReason.cardNotFound,
        ),
      );
    });

    test('コストが足りない場合、notEnoughCostで失敗する', () {
      final card = buildCard(instanceId: 'card1', currentCost: 5);
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(
        result,
        const ValidationResultFailure(
          reason: ActionFailureReason.notEnoughCost,
        ),
      );
    });

    test('手札に複数カードがある場合、instanceIdが一致するカードのコストのみ判定される', () {
      final cheapCard = buildCard(instanceId: 'cheap');
      final expensiveCard = buildCard(instanceId: 'expensive', currentCost: 10);
      final player = buildPlayer(
        id: playerId,
        hand: [expensiveCard, cheapCard],
      );
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'cheap',
        actionSequenceNumber: 2,
      );

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(result, const ValidationResultSuccess());
    });
  });
}

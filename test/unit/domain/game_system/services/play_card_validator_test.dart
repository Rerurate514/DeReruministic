import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/validation_result.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';

const cardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def_1'),
  name: 'Strike',
  baseCost: 1,
  effects: [],
  states: [],
);

GameCard buildCard({
  required String instanceId,
  int currentCost = 1,
  int enteredHandAtTurn = 0,
}) {
  return GameCard(
    instanceId: GameCardInstanceId(value: instanceId),
    definition: cardDef,
    currentCost: currentCost,
    enteredHandAtTurn: enteredHandAtTurn,
  );
}

PlayerState buildPlayer({
  required PlayerId id,
  int currentCost = 3,
  List<GameCard> hand = const [],
}) {
  return PlayerState(
    id: id,
    hp: 20,
    maxHp: 20,
    shield: 0,
    currentCost: currentCost,
    deck: const [],
    hand: hand,
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
  required BattlePhase battlePhase,
  required PlayerId turnOwner,
}) {
  return GameState(
    seed: 0,
    players: players,
    phase: GamePhase(battlePhase: battlePhase, turnOwner: turnOwner),
    turnCount: 0,
    initialTurnOwner: turnOwner,
  );
}

GameActionPlayCard buildAction({
  required PlayerId playerId,
  required String cardInstanceId,
}) {
  return GameActionPlayCard(
    id: const GameActionsId(value: 'action_1'),
    playerId: playerId,
    cardInstanceId: GameCardInstanceId(value: cardInstanceId),
  );
}

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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'card1');

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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'card1');

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
      final action = buildAction(playerId: playerId, cardInstanceId: 'card1');

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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: otherPlayerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'card1');

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
      final action = buildAction(playerId: playerId, cardInstanceId: 'card1');

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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: playerId,
      );
      final action = buildAction(
        playerId: otherPlayerId, // playersマップに存在しない
        cardInstanceId: 'card1',
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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: playerId,
      );
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'not_in_hand',
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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'card1');

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
        battlePhase: BattlePhase.mainPhase,
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'cheap');

      final result = validator.validate(
        state: state,
        cardUsedPlayerId: action.playerId,
        usedCardInstanceId: action.cardInstanceId,
      );

      expect(result, const ValidationResultSuccess());
    });
  });
}

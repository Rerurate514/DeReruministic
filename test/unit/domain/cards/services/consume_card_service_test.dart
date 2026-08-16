import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/validation_result.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'consume_card_service_test.mocks.dart';

const normalCardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def_normal'),
  name: 'Strike',
  baseCost: 1,
  effects: [],
  states: [],
);

const exhaustCardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def_exhaust'),
  name: 'Ultimate',
  baseCost: 3,
  effects: [],
  states: [CardStates.exhaust()],
);

GameCard buildCard({
  required String instanceId,
  CardDefinition definition = normalCardDef,
  int currentCost = 1,
}) {
  return GameCard(
    instanceId: GameCardInstanceId(value: instanceId),
    definition: definition,
    currentCost: currentCost,
    enteredHandAtTurn: 0,
  );
}

PlayerState buildPlayer({
  required PlayerId id,
  int currentCost = 3,
  List<GameCard> hand = const [],
  List<GameCard> graveyard = const [],
  List<GameCard> exhausted = const [],
}) {
  return PlayerState(
    id: id,
    hp: 20,
    maxHp: 20,
    shield: 0,
    currentCost: currentCost,
    deck: const [],
    hand: hand,
    graveyard: graveyard,
    exhausted: exhausted,
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
  BattlePhase battlePhase = BattlePhase.mainPhase,
}) {
  return GameState(
    seed: 0,
    players: players,
    phase: GamePhase(battlePhase: battlePhase, turnOwner: turnOwner),
    turnCount: 0,
    initialTurnOwner: turnOwner,
  );
}

@GenerateNiceMocks([MockSpec<PlayCardValidator>()])
void main() {
  const playerId = PlayerId(value: 'player1');
  const otherPlayerId = PlayerId(value: 'player2');

  late MockPlayCardValidator mockValidator;
  late ConsumeCardService service;

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult.success(
        state: buildState(
          players: {playerId: buildPlayer(id: playerId)},
          turnOwner: playerId,
        ),
        steps: const [],
      ),
    );

    provideDummy<ValidationResult>(const ValidationResult.success());

    mockValidator = MockPlayCardValidator();
    service = ConsumeCardService(playCardValidator: mockValidator);
  });

  group('ConsumeCardService.execute', () {
    test(
      'sourcePlayerIdがstate.playersに存在しない場合、playerNotFoundで失敗しvalidatorは呼ばれない',
      () {
        final state = buildState(
          players: {playerId: buildPlayer(id: playerId)},
          turnOwner: playerId,
        );
        final card = buildCard(instanceId: 'card1');

        final result = service.execute(
          state: state,
          sourcePlayerId: otherPlayerId,
          card: card,
        );

        expect(result, isA<ApplyActionResultFailure>());
        final failure = result as ApplyActionResultFailure;
        expect(failure.reason, ActionFailureReason.playerNotFound);
        expect(failure.state, state);
        verifyNever(
          mockValidator.validate(
            state: anyNamed('state'),
            cardUsedPlayerId: anyNamed('cardUsedPlayerId'),
            usedCardInstanceId: anyNamed('usedCardInstanceId'),
          ),
        );
      },
    );

    test('validatorが失敗を返す場合、そのreasonのままfailureを返し状態は変化しない', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      when(
        mockValidator.validate(
          state: state,
          cardUsedPlayerId: playerId,
          usedCardInstanceId: card.instanceId,
        ),
      ).thenReturn(
        const ValidationResultFailure(
          reason: ActionFailureReason.notEnoughCost,
        ),
      );

      final result = service.execute(
        state: state,
        sourcePlayerId: playerId,
        card: card,
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.notEnoughCost);
      // カードは移動していない(手札のまま)
      expect(failure.state.players[playerId]!.hand, [card]);
      expect(failure.state.players[playerId]!.graveyard, isEmpty);
    });

    test('validatorが成功を返しexhaustカードでない場合、カードは手札からgraveyardへ移動する', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      when(
        mockValidator.validate(
          state: state,
          cardUsedPlayerId: playerId,
          usedCardInstanceId: card.instanceId,
        ),
      ).thenReturn(const ValidationResultSuccess());

      final result = service.execute(
        state: state,
        sourcePlayerId: playerId,
        card: card,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[playerId]!;
      expect(updatedPlayer.hand, isEmpty);
      expect(updatedPlayer.graveyard, [card]);
      expect(updatedPlayer.exhausted, isEmpty);
    });

    test('validatorが成功を返しexhaustカードの場合、カードは手札からexhaustedへ移動する', () {
      final card = buildCard(instanceId: 'card1', definition: exhaustCardDef);
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      when(
        mockValidator.validate(
          state: state,
          cardUsedPlayerId: playerId,
          usedCardInstanceId: card.instanceId,
        ),
      ).thenReturn(const ValidationResultSuccess());

      final result = service.execute(
        state: state,
        sourcePlayerId: playerId,
        card: card,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[playerId]!;
      expect(updatedPlayer.hand, isEmpty);
      expect(updatedPlayer.exhausted, [card]);
      expect(updatedPlayer.graveyard, isEmpty);
    });

    test('成功時、GameStepEvent.cardMovedZoneが正しい内容で1件返る(通常カード)', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      when(
        mockValidator.validate(
          state: state,
          cardUsedPlayerId: playerId,
          usedCardInstanceId: card.instanceId,
        ),
      ).thenReturn(const ValidationResultSuccess());

      final result = service.execute(
        state: state,
        sourcePlayerId: playerId,
        card: card,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(1));
      final step = success.steps.single as GameStepEventCardMovedZone;
      expect(step.playerId, playerId);
      expect(step.cardInstanceIds, [card.instanceId]);
      expect(step.zoneFrom, CardZone.hand);
      expect(step.zoneTo, CardZone.graveyard);
    });

    test('成功時、GameStepEvent.cardMovedZoneが正しい内容で1件返る(exhaustカード)', () {
      final card = buildCard(instanceId: 'card1', definition: exhaustCardDef);
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      when(
        mockValidator.validate(
          state: state,
          cardUsedPlayerId: playerId,
          usedCardInstanceId: card.instanceId,
        ),
      ).thenReturn(const ValidationResultSuccess());

      final result = service.execute(
        state: state,
        sourcePlayerId: playerId,
        card: card,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.steps, hasLength(1));
      final step = success.steps.single as GameStepEventCardMovedZone;
      expect(step.zoneFrom, CardZone.hand);
      expect(step.zoneTo, CardZone.exhausted);
    });

    test(
      'validatorに正しい引数(state, cardUsedPlayerId, usedCardInstanceId)で1回だけ呼ばれる',
      () {
        final card = buildCard(instanceId: 'card1');
        final player = buildPlayer(id: playerId, hand: [card]);
        final state = buildState(
          players: {playerId: player},
          turnOwner: playerId,
        );

        when(
          mockValidator.validate(
            state: state,
            cardUsedPlayerId: playerId,
            usedCardInstanceId: card.instanceId,
          ),
        ).thenReturn(const ValidationResultSuccess());

        service.execute(state: state, sourcePlayerId: playerId, card: card);

        verify(
          mockValidator.validate(
            state: state,
            cardUsedPlayerId: playerId,
            usedCardInstanceId: card.instanceId,
          ),
        ).called(1);
      },
    );

    test('他プレイヤーの状態は変化しない', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, hand: [card]);
      final other = buildPlayer(id: otherPlayerId, currentCost: 5);
      final state = buildState(
        players: {playerId: player, otherPlayerId: other},
        turnOwner: playerId,
      );

      when(
        mockValidator.validate(
          state: state,
          cardUsedPlayerId: playerId,
          usedCardInstanceId: card.instanceId,
        ),
      ).thenReturn(const ValidationResultSuccess());

      final result = service.execute(
        state: state,
        sourcePlayerId: playerId,
        card: card,
      );

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[otherPlayerId], other);
    });
  });
}

import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/deck_restoration_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DeckRestorationService deckRestorationService;

  const targetPlayerId = PlayerId(value: 'player_1');
  const card1InstanceId = GameCardInstanceId(value: 'card_inst_1');
  const card2InstanceId = GameCardInstanceId(value: 'card_inst_2');

  const dummyCardDef = CardDefinition(
    cardDefId: CardDefinitionId(value: 'def_1'),
    name: 'Strike',
    baseCost: 1,
    effects: [],
    states: [],
  );

  const dummyCard1 = GameCard(
    instanceId: card1InstanceId,
    definition: dummyCardDef,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  const dummyCard2 = GameCard(
    instanceId: card2InstanceId,
    definition: dummyCardDef,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  final emptyDeckPlayer =
      PlayerState.create(
        id: targetPlayerId,
        deck: const [],
      ).copyWith(
        graveyard: const [dummyCard1, dummyCard2],
      );

  final baseState = GameState(
    seed: 12345,
    players: {targetPlayerId: emptyDeckPlayer},
    phase: GamePhase.init(targetPlayerId),
    turnCount: 1,
    initialTurnOwner: targetPlayerId,
  );

  setUp(() {
    deckRestorationService = DeckRestorationService();
  });

  group('DeckRestorationService', () {
    test('targetPlayerIdが存在しない場合、noStepsを返す', () {
      const nonExistentPlayerId = PlayerId(value: 'unknown_player');

      final result =
          deckRestorationService.execute(
                baseState,
                nonExistentPlayerId,
                Random(12345),
              )
              as ApplyActionResultSuccess;

      expect(result.steps, isEmpty);
      expect(result.state, equals(baseState));
    });

    test('デッキが空でない場合、復元を行わずnoStepsを返す', () {
      final playerWithDeck = emptyDeckPlayer.copyWith(
        deck: const [dummyCard1],
      );
      final stateWithDeck = baseState.copyWith(
        players: {targetPlayerId: playerWithDeck},
      );

      final result =
          deckRestorationService.execute(
                stateWithDeck,
                targetPlayerId,
                Random(12345),
              )
              as ApplyActionResultSuccess;

      expect(result.steps, isEmpty);
      expect(result.state, equals(stateWithDeck));
    });

    test('デッキが空の場合、墓地のカードがデッキに移動しシャッフルされる', () {
      final result =
          deckRestorationService.execute(
                baseState,
                targetPlayerId,
                Random(12345),
              )
              as ApplyActionResultSuccess;

      final updatedPlayer = result.state.players[targetPlayerId]!;
      expect(updatedPlayer.graveyard, isEmpty);
      expect(updatedPlayer.deck.length, equals(2));
      expect(updatedPlayer.deck, containsAll([dummyCard1, dummyCard2]));

      expect(result.steps.length, equals(2));

      final moveEvent = result.steps[0] as GameStepEventCardMovedZone;
      expect(moveEvent.playerId, equals(targetPlayerId));
      expect(moveEvent.zoneFrom, equals(CardZone.graveyard));
      expect(moveEvent.zoneTo, equals(CardZone.deck));
      expect(moveEvent.cardInstanceIds.length, equals(2));
      expect(
        moveEvent.cardInstanceIds,
        containsAll([card1InstanceId, card2InstanceId]),
      );

      final restoredEvent = result.steps[1] as GameStepEventDeckRestored;
      expect(restoredEvent.playerId, equals(targetPlayerId));
      expect(restoredEvent.count, equals(2));
    });

    test('墓地も空の場合、空のデッキが生成されcountが0のイベントが発行される', () {
      final emptyGraveyardPlayer = emptyDeckPlayer.copyWith(
        graveyard: const [],
      );
      final emptyGraveyardState = baseState.copyWith(
        players: {targetPlayerId: emptyGraveyardPlayer},
      );

      final result =
          deckRestorationService.execute(
                emptyGraveyardState,
                targetPlayerId,
                Random(12345),
              )
              as ApplyActionResultSuccess;

      final updatedPlayer = result.state.players[targetPlayerId]!;
      expect(updatedPlayer.deck, isEmpty);
      expect(updatedPlayer.graveyard, isEmpty);

      expect(result.steps.length, equals(2));

      final moveEvent = result.steps[0] as GameStepEventCardMovedZone;
      expect(moveEvent.cardInstanceIds, isEmpty);

      final restoredEvent = result.steps[1] as GameStepEventDeckRestored;
      expect(restoredEvent.count, equals(0));
    });

    test('同じシード値のRandomを渡した場合は決定論的にデッキの並び順が一致する', () {
      final result1 = deckRestorationService.execute(
        baseState,
        targetPlayerId,
        Random(42),
      );

      final result2 = deckRestorationService.execute(
        baseState,
        targetPlayerId,
        Random(42),
      );

      final deck1 = result1.state.players[targetPlayerId]!.deck;
      final deck2 = result2.state.players[targetPlayerId]!.deck;

      expect(deck1, equals(deck2));
    });
  });
}

import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/services/deck_restoration_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'card_draw_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DeckRestorationService>()])
void main() {
  late MockDeckRestorationService mockDeckRestorationService;
  late CardDrawService cardDrawService;

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

  final basePlayer = PlayerState.create(
    id: targetPlayerId,
    deck: const [dummyCard1, dummyCard2],
  );

  final baseState = GameState(
    seed: 12345,
    players: {targetPlayerId: basePlayer},
    phase: GamePhase.init(targetPlayerId),
    turnCount: 1,
  );

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult(
        state: baseState,
        steps: const [],
      ),
    );

    mockDeckRestorationService = MockDeckRestorationService();
    cardDrawService = CardDrawService(
      deckRestorationService: mockDeckRestorationService,
    );
  });

  group('CardDrawService', () {
    test('targetPlayerIdが存在しない場合、noStepsを返す', () {
      const nonExistentPlayerId = PlayerId(value: 'unknown_player');

      final result = cardDrawService.execute(
        baseState,
        nonExistentPlayerId,
        1,
      );

      expect(result.steps, isEmpty);
      expect(result.state, equals(baseState));
      verifyNever(mockDeckRestorationService.execute(any, any, any));
    });

    test('amountが0以下の場合、noStepsを返す', () {
      final result = cardDrawService.execute(
        baseState,
        targetPlayerId,
        0,
      );

      expect(result.steps, isEmpty);
      expect(result.state, equals(baseState));
      verifyNever(mockDeckRestorationService.execute(any, any, any));
    });

    test('山札から指定枚数を引く（引き終えた後も山札が残っている場合、復元処理は呼ばれない）', () {
      final result = cardDrawService.execute(
        baseState,
        targetPlayerId,
        1,
      );

      final updatedPlayer = result.state.players[targetPlayerId]!;
      expect(updatedPlayer.deck, equals([dummyCard2]));
      expect(updatedPlayer.hand, equals([dummyCard1]));

      expect(result.steps.length, equals(2));

      final valueChangedStep = result.steps[0] as GameStepEventValueChanged;
      expect(valueChangedStep.type, equals(GameStepType.cardsDrawn));
      expect(valueChangedStep.targetPlayerId, equals(targetPlayerId));
      expect(valueChangedStep.amount, equals(1));

      final cardMovedStep = result.steps[1] as GameStepEventCardZoneMoved;
      expect(cardMovedStep.type, equals(GameStepType.cardMovedZone));
      expect(cardMovedStep.playerId, equals(targetPlayerId));
      expect(cardMovedStep.cardInstanceIds, equals([card1InstanceId]));
      expect(cardMovedStep.zoneFrom, equals(CardZone.deck));
      expect(cardMovedStep.zoneTo, equals(CardZone.hand));

      verifyNever(mockDeckRestorationService.execute(any, any, any));
    });

    test('山札以上の枚数を要求された場合、山札の全カードを引く', () {
      const restorationStep = GameStepEvent.deckRestored(
        type: GameStepType.deckRestored,
        playerId: targetPlayerId,
        count: 2,
      );

      final restoredState = baseState.copyWith(seed: 99999);

      when(mockDeckRestorationService.execute(any, any, any)).thenReturn(
        ApplyActionResult(
          state: restoredState,
          steps: const [restorationStep],
        ),
      );

      final result = cardDrawService.execute(
        baseState,
        targetPlayerId,
        5,
      );

      expect(result.steps.length, equals(3));
      expect(result.steps[2], equals(restorationStep));

      verify(
        mockDeckRestorationService.execute(
          argThat(
            predicate<GameState>((s) {
              final p = s.players[targetPlayerId]!;
              return p.deck.isEmpty && p.hand.length == 2;
            }),
          ),
          argThat(equals(targetPlayerId)),
          argThat(isA<Random>()),
        ),
      ).called(1);
    });

    test('引き終えて山札が空になる場合、DeckRestorationServiceが正しく呼び出される', () {
      final singleCardPlayer = PlayerState.create(
        id: targetPlayerId,
        deck: const [dummyCard1],
      );
      final singleCardState = baseState.copyWith(
        players: {targetPlayerId: singleCardPlayer},
      );

      const restorationStep = GameStepEvent.deckRestored(
        type: GameStepType.deckRestored,
        playerId: targetPlayerId,
        count: 1,
      );

      when(mockDeckRestorationService.execute(any, any, any)).thenReturn(
        ApplyActionResult(
          state: singleCardState,
          steps: const [restorationStep],
        ),
      );

      final result = cardDrawService.execute(
        singleCardState,
        targetPlayerId,
        1,
      );

      expect(result.steps.length, equals(3));
      expect(result.steps[2], equals(restorationStep));

      verify(
        mockDeckRestorationService.execute(
          any,
          targetPlayerId,
          any,
        ),
      ).called(1);
    });
  });
}

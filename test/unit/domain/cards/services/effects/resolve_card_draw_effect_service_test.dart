import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/services/deck_restoration_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../helpers/game_test_helpers.dart';
import 'resolve_card_draw_effect_service_test.mocks.dart';

const dummyCardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def1'),
  name: 'Dummy',
  baseCost: 1,
  effects: [],
  states: [],
);

@GenerateNiceMocks([MockSpec<DeckRestorationService>()])
void main() {
  const playerId = PlayerId(value: 'player1');
  const otherPlayerId = PlayerId(value: 'player2');

  late MockDeckRestorationService mockDeckRestorationService;
  late CardDrawService service;

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult.success(
        state: buildState(
          players: {playerId: buildPlayer(id: playerId)},
        ),
        steps: const [],
      ),
    );

    mockDeckRestorationService = MockDeckRestorationService();
    service = CardDrawService(
      deckRestorationService: mockDeckRestorationService,
    );
  });

  group('CardDrawService.execute', () {
    test('targetPlayerIdが存在しない場合、noStepsで元のstateをそのまま返す', () {
      final state = buildState(
        players: {playerId: buildPlayer(id: playerId)},
        turnOwner: playerId,
      );

      final result = service.execute(state, otherPlayerId, 3);

      expect(result, isA<ApplyActionResultSuccess>());
      expect((result as ApplyActionResultSuccess).state, state);
      expect(result.steps, isEmpty);
      verifyZeroInteractions(mockDeckRestorationService);
    });

    test('amountが0以下の場合、noStepsで元のstateをそのまま返す', () {
      final card = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, deck: [card]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      final result = service.execute(state, playerId, 0);

      expect(result, isA<ApplyActionResultSuccess>());
      expect((result as ApplyActionResultSuccess).state, state);
      verifyZeroInteractions(mockDeckRestorationService);
    });

    test('デッキが空の場合、drawCountが0となりnoStepsを返しdeckRestorationServiceは呼ばれない', () {
      final player = buildPlayer(id: playerId);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      final result = service.execute(state, playerId, 3);

      expect(result, isA<ApplyActionResultSuccess>());
      expect((result as ApplyActionResultSuccess).state, state);
      verifyZeroInteractions(mockDeckRestorationService);
    });

    test('デッキ残数がamount以上の場合、amount枚引き手札とデッキが正しく更新される(復元は呼ばれない)', () {
      final card1 = buildCard(instanceId: 'card1');
      final card2 = buildCard(instanceId: 'card2');
      final card3 = buildCard(instanceId: 'card3');
      final player = buildPlayer(
        id: playerId,
        deck: [card1, card2, card3],
      );
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );

      final result = service.execute(state, playerId, 2);

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[playerId]!;

      expect(updatedPlayer.hand, [card1, card2]);
      expect(updatedPlayer.deck, [card3]); // 残数1(空ではない)

      expect(success.steps, hasLength(2));
      final drawStep = success.steps[0] as GameStepEventCardsDrawn;
      expect(drawStep.playerId, playerId);
      expect(drawStep.cardInstanceIds, [card1.instanceId, card2.instanceId]);
      expect(drawStep.zoneFrom, CardZone.deck);
      expect(drawStep.zoneTo, CardZone.hand);

      final moveStep = success.steps[1] as GameStepEventCardMovedZone;
      expect(moveStep.cardInstanceIds, [card1.instanceId, card2.instanceId]);
      expect(moveStep.zoneFrom, CardZone.deck);
      expect(moveStep.zoneTo, CardZone.hand);

      verifyZeroInteractions(mockDeckRestorationService);
    });

    test('amountがデッキ残数を超える場合、デッキの枚数分だけ引く', () {
      final card1 = buildCard(instanceId: 'card1');
      final player = buildPlayer(id: playerId, deck: [card1]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
      );
      final restoredState = buildState(
        players: {
          playerId: buildPlayer(id: playerId, hand: [card1]),
        },
        turnOwner: playerId,
      );

      when(
        mockDeckRestorationService.execute(any, playerId, any),
      ).thenReturn(
        ApplyActionResult.success(state: restoredState, steps: const []),
      );

      final result = service.execute(state, playerId, 5); // deckは1枚しかない

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final drawStep = success.steps[0] as GameStepEventCardsDrawn;
      expect(drawStep.cardInstanceIds, [card1.instanceId]); // 1枚だけ引く
    });

    test('デッキを引き切った場合、deckRestorationServiceが呼ばれその結果のstateと合成したstepsが返る', () {
      final card1 = buildCard(instanceId: 'card1');
      final card2 = buildCard(instanceId: 'card2');
      final player = buildPlayer(id: playerId, deck: [card1, card2]);
      final state = buildState(
        players: {playerId: player},
        turnOwner: playerId,
        seed: 42,
      );

      final expectedNewState = buildState(
        players: {
          playerId: buildPlayer(
            id: playerId,
            hand: [card1, card2],
          ),
        },
        turnOwner: playerId,
        seed: 42,
      );

      final restoredPlayer = buildPlayer(
        id: playerId,
        deck: [buildCard(instanceId: 'graveyardCard1')],
        hand: [card1, card2],
      );
      final restoredState = buildState(
        players: {playerId: restoredPlayer},
        turnOwner: playerId,
        seed: 42,
      );
      const restoreStep = GameStepEvent.cardMovedZone(
        playerId: playerId,
        cardInstanceIds: [GameCardInstanceId(value: 'graveyardCard1')],
        zoneFrom: CardZone.graveyard,
        zoneTo: CardZone.deck,
      );

      when(
        mockDeckRestorationService.execute(expectedNewState, playerId, any),
      ).thenReturn(
        ApplyActionResult.success(
          state: restoredState,
          steps: [restoreStep],
        ),
      );

      final result = service.execute(state, playerId, 2);

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      // 最終的なstateはdeckRestorationServiceが返したもの
      expect(success.state, restoredState);
      // stepsはdraw分(2件) + deckRestorationServiceが返したstepsの順で結合される
      expect(success.steps, hasLength(3));
      expect(success.steps[0], isA<GameStepEventCardsDrawn>());
      expect(success.steps[1], isA<GameStepEventCardMovedZone>());
      expect(success.steps[2], restoreStep);

      verify(
        mockDeckRestorationService.execute(expectedNewState, playerId, any),
      ).called(1);
    });

    test(
      'デッキを引き切りdeckRestorationServiceが失敗を返す場合、その失敗をそのまま返す(drawのstepsとは合成しない)',
      () {
        final card1 = buildCard(instanceId: 'card1');
        final player = buildPlayer(id: playerId, deck: [card1]);
        final state = buildState(
          players: {playerId: player},
          turnOwner: playerId,
        );

        final failure = ApplyActionResult.failure(
          state: state,
          reason: ActionFailureReason.playerNotFound,
        );

        when(
          mockDeckRestorationService.execute(any, playerId, any),
        ).thenReturn(failure);

        final result = service.execute(state, playerId, 1);

        expect(result, failure);
      },
    );
  });
}

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_start_draw_cards_service_test.mocks.dart';

@GenerateMocks([CardDrawService])
void main() {
  late MockCardDrawService mockCardDrawService;
  late GameStartDrawCardsService gameStartDrawCardsService;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');

  const cardDefId = CardDefinitionId(value: 'def_1');
  const cardDef = CardDefinition(
    cardDefId: cardDefId,
    name: 'Strike',
    baseCost: 1,
    effects: [],
    states: [],
  );

  const cardA1 = GameCard(
    instanceId: GameCardInstanceId(value: 'inst_a1'),
    definition: cardDef,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  const cardB1 = GameCard(
    instanceId: GameCardInstanceId(value: 'inst_b1'),
    definition: cardDef,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  final playerAState = PlayerState.create(
    id: playerAId,
    deck: const [cardA1],
  );

  final playerBState = PlayerState.create(
    id: playerBId,
    deck: const [cardB1],
  );

  final baseState = GameState(
    players: {
      playerAId: playerAState,
      playerBId: playerBState,
    },
    phase: GamePhase.init(playerAId),
    turnCount: 0,
    initialTurnOwner: playerAId,
    metadata: const SystemMetadata(seed: 12345, actionSequenceNumber: 1),
  );

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult.success(
        state: baseState,
        steps: const [],
      ),
    );

    mockCardDrawService = MockCardDrawService();
    gameStartDrawCardsService = GameStartDrawCardsService(
      cardDrawService: mockCardDrawService,
    );
  });

  group('GameStartDrawCardsService', () {
    test('全プレイヤーに対してCardDrawServiceが順次実行され、State更新とStepの累積が行われる', () {
      const stepA = GameStepEventCardsDrawn(
        playerId: playerAId,
        cardInstanceIds: [GameCardInstanceId(value: 'inst_a1')],
        zoneFrom: CardZone.deck,
        zoneTo: CardZone.hand,
      );

      const stepB = GameStepEventCardsDrawn(
        playerId: playerBId,
        cardInstanceIds: [GameCardInstanceId(value: 'inst_b1')],
        zoneFrom: CardZone.deck,
        zoneTo: CardZone.hand,
      );

      final stateAfterPlayerA = baseState.copyWith(
        players: {
          playerAId: playerAState.copyWith(
            deck: const [],
            hand: const [cardA1],
          ),
          playerBId: playerBState,
        },
      );

      final stateAfterPlayerB = stateAfterPlayerA.copyWith(
        players: {
          playerAId: playerAState.copyWith(
            deck: const [],
            hand: const [cardA1],
          ),
          playerBId: playerBState.copyWith(
            deck: const [],
            hand: const [cardB1],
          ),
        },
      );

      when(
        mockCardDrawService.execute(
          baseState,
          playerAId,
          GameSystemConstants.initialGameStartDrawCardsCount,
        ),
      ).thenReturn(
        ApplyActionResult.success(
          state: stateAfterPlayerA,
          steps: const [stepA],
        ),
      );

      when(
        mockCardDrawService.execute(
          stateAfterPlayerA,
          playerBId,
          GameSystemConstants.initialGameStartDrawCardsCount,
        ),
      ).thenReturn(
        ApplyActionResult.success(
          state: stateAfterPlayerB,
          steps: const [stepB],
        ),
      );

      final result =
          gameStartDrawCardsService.execute(baseState)
              as ApplyActionResultSuccess;

      verify(
        mockCardDrawService.execute(
          baseState,
          playerAId,
          GameSystemConstants.initialGameStartDrawCardsCount,
        ),
      ).called(1);

      verify(
        mockCardDrawService.execute(
          stateAfterPlayerA,
          playerBId,
          GameSystemConstants.initialGameStartDrawCardsCount,
        ),
      ).called(1);

      expect(result.state, equals(stateAfterPlayerB));
      expect(result.steps.length, equals(2));
      expect(result.steps, equals([stepA, stepB]));
    });

    test('プレイヤーリストが空の場合、状態は変化せず空のstepsを返す', () {
      final emptyPlayerState = baseState.copyWith(players: {});

      final result =
          gameStartDrawCardsService.execute(emptyPlayerState)
              as ApplyActionResultSuccess;

      verifyNever(mockCardDrawService.execute(any, any, any));

      expect(result.state, equals(emptyPlayerState));
      expect(result.steps, isEmpty);
    });
  });
}

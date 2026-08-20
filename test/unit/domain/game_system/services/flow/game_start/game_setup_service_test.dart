import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/create_deck_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_setup_service_test.mocks.dart';

@GenerateMocks([CreateDeckService])
void main() {
  late MockCreateDeckService mockCreateDeckService;
  late GameSetupService gameSetupService;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');

  const cardDefIdA = CardDefinitionId(value: 'def_1');
  const cardDefIdB = CardDefinitionId(value: 'def_2');

  const cardDefA = CardDefinition(
    cardDefId: cardDefIdA,
    name: 'Strike',
    baseCost: 1,
    effects: [],
    states: [],
  );

  const cardDefB = CardDefinition(
    cardDefId: cardDefIdB,
    name: 'Defend',
    baseCost: 1,
    effects: [],
    states: [],
  );

  const cardA = GameCard(
    instanceId: GameCardInstanceId(value: 'inst_a'),
    definition: cardDefA,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  const cardB = GameCard(
    instanceId: GameCardInstanceId(value: 'inst_b'),
    definition: cardDefB,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  const playerA = Player(
    id: playerAId,
    name: 'player A',
    deckRecipe: [cardDefIdA],
  );

  const playerB = Player(
    id: playerBId,
    name: 'player B',
    deckRecipe: [cardDefIdB],
  );

  const allCardDefs = [cardDefA, cardDefB];

  setUp(() {
    mockCreateDeckService = MockCreateDeckService();
    gameSetupService = GameSetupService(
      createDeckService: mockCreateDeckService,
    );
  });

  group('GameSetupService', () {
    test('両プレイヤーのデッキ生成と初期GameStateおよびgameStartedイベントが正しく構築される', () {
      const seed = 12345;

      when(
        mockCreateDeckService.execute(any, playerA.deckRecipe, any),
      ).thenReturn([cardA]);
      when(
        mockCreateDeckService.execute(any, playerB.deckRecipe, any),
      ).thenReturn([cardB]);

      final result =
          gameSetupService.execute(
                playerAId: playerA.id,
                playerBId: playerB.id,
                playerADeckRecipe: playerA.deckRecipe,
                playerBDeckRecipe: playerB.deckRecipe,
                cardDefs: allCardDefs,
                seed: seed,
              )
              as ApplyActionResultSuccess;

      verify(
        mockCreateDeckService.execute(
          allCardDefs,
          playerA.deckRecipe,
          argThat(isA<Random>()),
        ),
      ).called(1);

      verify(
        mockCreateDeckService.execute(
          allCardDefs,
          playerB.deckRecipe,
          argThat(isA<Random>()),
        ),
      ).called(1);

      final state = result.state;
      expect(state.metadata.seed, equals(seed));
      expect(state.turnCount, equals(1));
      expect(state.phase.battlePhase, equals(BattlePhase.battleStart));
      expect(
        [playerAId, playerBId],
        contains(state.phase.turnOwner),
      );

      final statePlayerA = state.players[playerAId]!;
      expect(statePlayerA.id, equals(playerAId));
      expect(statePlayerA.deck, equals([cardA]));

      final statePlayerB = state.players[playerBId]!;
      expect(statePlayerB.id, equals(playerBId));
      expect(statePlayerB.deck, equals([cardB]));

      expect(result.steps.length, equals(1));
      final step = result.steps.first as GameStepEventGameStarted;
      expect(step.firstTurnPlayerId, equals(state.phase.turnOwner));
    });

    test('同じシード値のRandomを渡した場合は先攻プレイヤー決定が決定論的になる', () {
      const seed = 42;

      when(mockCreateDeckService.execute(any, any, any)).thenReturn([]);

      final result1 =
          gameSetupService.execute(
                playerAId: playerA.id,
                playerBId: playerB.id,
                playerADeckRecipe: playerA.deckRecipe,
                playerBDeckRecipe: playerB.deckRecipe,
                cardDefs: allCardDefs,
                seed: seed,
              )
              as ApplyActionResultSuccess;

      final result2 =
          gameSetupService.execute(
                playerAId: playerA.id,
                playerBId: playerB.id,
                playerADeckRecipe: playerA.deckRecipe,
                playerBDeckRecipe: playerB.deckRecipe,
                cardDefs: allCardDefs,
                seed: seed,
              )
              as ApplyActionResultSuccess;

      expect(
        result1.state.phase.turnOwner,
        equals(result2.state.phase.turnOwner),
      );

      final step1 = result1.steps.first as GameStepEventGameStarted;
      final step2 = result2.steps.first as GameStepEventGameStarted;
      expect(step1.firstTurnPlayerId, equals(step2.firstTurnPlayerId));
    });
  });
}

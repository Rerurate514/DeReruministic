import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/defeat_process_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'card_draw_start_turn_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CardDrawService>(),
  MockSpec<DefeatProcessService>(),
])
void main() {
  late MockCardDrawService mockCardDrawService;
  late MockDefeatProcessService mockDefeatProcessService;
  late CardDrawStartTurnService cardDrawStartTurnService;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');

  const cardDef = CardDefinition(
    cardDefId: CardDefinitionId(value: 'def_1'),
    name: 'Strike',
    baseCost: 1,
    effects: [],
    states: [],
  );

  final cards = List.generate(
    GameSystemConstants.defaultDrawCount,
    (i) => GameCard(
      instanceId: GameCardInstanceId(value: 'inst_$i'),
      definition: cardDef,
      currentCost: 1,
      enteredHandAtTurn: 0,
    ),
  );

  final playerAState = PlayerState.create(
    id: playerAId,
    deck: cards,
  );

  final playerBState = PlayerState.create(
    id: playerBId,
    deck: const [],
  );

  final baseState = GameState(
    seed: 12345,
    players: {
      playerAId: playerAState,
      playerBId: playerBState,
    },
    phase: GamePhase.init(playerAId),
    turnCount: 1,
  );

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult(
        state: baseState,
        steps: const [],
      ),
    );

    mockCardDrawService = MockCardDrawService();
    mockDefeatProcessService = MockDefeatProcessService();
    cardDrawStartTurnService = CardDrawStartTurnService(
      cardDrawService: mockCardDrawService,
      defeatProcessService: mockDefeatProcessService,
    );
  });

  group('CardDrawStartTurnService', () {
    test('山札+墓地が十分な場合、defaultDrawCount分のドロー処理がCardDrawServiceに委譲される', () {
      const step = GameStepEvent.valueChanged(
        type: GameStepType.cardsDrawn,
        targetPlayerId: playerAId,
        amount: GameSystemConstants.defaultDrawCount,
      );

      final expectedState = baseState.copyWith(
        players: {
          playerAId: playerAState.copyWith(
            deck: const [],
            hand: cards,
          ),
          playerBId: playerBState,
        },
      );

      final expectedResult = ApplyActionResult(
        state: expectedState,
        steps: const [step],
      );

      when(
        mockCardDrawService.execute(
          baseState,
          playerAId,
          GameSystemConstants.defaultDrawCount,
        ),
      ).thenReturn(expectedResult);

      final result = cardDrawStartTurnService.execute(baseState);

      verify(
        mockCardDrawService.execute(
          baseState,
          playerAId,
          GameSystemConstants.defaultDrawCount,
        ),
      ).called(1);
      verifyZeroInteractions(mockDefeatProcessService);

      expect(result.state, equals(expectedState));
      expect(result.steps, equals([step]));
    });

    test('山札+墓地の枚数がドロー要求量に満たない場合、DefeatProcessServiceに委譲される', () {
      final emptyPlayerState = playerAState.copyWith(
        deck: const [],
        graveyard: const [],
      );
      final emptyDeckState = baseState.copyWith(
        players: {
          playerAId: emptyPlayerState,
          playerBId: playerBState,
        },
      );

      const defeatStep = GameStepEvent.gameEnded(
        type: GameStepType.gameEnded,
        winnerPlayerId: playerBId,
        reason: 'defeat_library_out',
      );

      final defeatResult = ApplyActionResult(
        state: emptyDeckState.copyWith(
          phase: const GamePhase(
            battlePhase: BattlePhase.battleEnd,
            turnOwner: playerAId,
          ),
        ),
        steps: const [defeatStep],
      );

      when(
        mockDefeatProcessService.execute(
          emptyDeckState,
          loserPlayerId: playerAId,
          reason: 'defeat_library_out',
        ),
      ).thenReturn(defeatResult);

      final result = cardDrawStartTurnService.execute(emptyDeckState);

      verify(
        mockDefeatProcessService.execute(
          emptyDeckState,
          loserPlayerId: playerAId,
          reason: 'defeat_library_out',
        ),
      ).called(1);
      verifyZeroInteractions(mockCardDrawService);

      expect(result.state, equals(defeatResult.state));
      expect(result.steps, equals([defeatStep]));
    });
  });
}

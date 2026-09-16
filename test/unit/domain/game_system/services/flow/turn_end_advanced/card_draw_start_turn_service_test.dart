import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'card_draw_start_turn_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CardDrawService>()])
void main() {
  provideDummy<ApplyActionResult>(
    ApplyActionResult.success(
      state: GameState(
        players: const {},
        phase: GamePhase.init(const PlayerId(value: '')),
        turnCount: 0,
        initialTurnOwner: const PlayerId(value: ''),
        taskQueue: QueueList.from([]),
        metadata: const SystemMetadata(seed: 0, actionSequenceNumber: 1),
      ),
      steps: const [],
    ),
  );

  late MockCardDrawService mockCardDrawService;
  late CardDrawStartTurnService cardDrawStartTurnService;
  late PlayerId playerAId;
  late PlayerId playerBId;
  late PlayerState playerAState;
  late PlayerState playerBState;
  late List<GameCard> cards;
  late GameState baseState;

  setUp(() {
    playerAId = const PlayerId(value: 'player_a');
    playerBId = const PlayerId(value: 'player_b');

    const cardDef = CardDefinition(
      cardDefId: CardDefinitionId(value: 'def_1'),
      name: 'Strike',
      baseCost: 1,
      effects: [],
      states: [],
    );

    cards = List.generate(
      GameSystemConstants.defaultDrawCount,
      (i) => GameCard(
        instanceId: GameCardInstanceId(value: 'inst_$i'),
        definition: cardDef,
        currentCost: 1,
        enteredHandAtTurn: 0,
      ),
    );

    playerAState = PlayerState.create(
      id: playerAId,
      deck: cards,
    );

    playerBState = PlayerState.create(
      id: playerBId,
      deck: const [],
    );

    baseState = GameState(
      players: {
        playerAId: playerAState,
        playerBId: playerBState,
      },
      phase: GamePhase.init(playerAId),
      turnCount: 1,
      initialTurnOwner: playerAId,
      taskQueue: QueueList.from([]),
      metadata: const SystemMetadata(seed: 12345, actionSequenceNumber: 1),
    );

    mockCardDrawService = MockCardDrawService();
    cardDrawStartTurnService = CardDrawStartTurnService(
      cardDrawService: mockCardDrawService,
    );
  });

  group('CardDrawStartTurnService', () {
    test('山札+墓地が十分な場合、defaultDrawCount分のドロー処理がCardDrawServiceに委譲される', () {
      const step = GameStepEventCardsDrawn(
        playerId: PlayerId(value: 'player_a'),
        instanceIds: [],
        zoneFrom: CardZone.deck,
        zoneTo: CardZone.hand,
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

      final expectedResult = ApplyActionResult.success(
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

      expect(result, equals(expectedResult));
    });

    test('drawBoostとdrawReductionのスタックを反映した枚数でCardDrawServiceに委譲される', () {
      final boostedPlayer = playerAState.copyWith(
        buffs: const [BuffState(buff: BuffTypes.drawBoost, stack: 2)],
        debuffs: const [
          DebuffState(debuff: DebuffTypes.drawReduction, stack: 1),
        ],
      );
      final boostedState = baseState.copyWith(
        players: {
          playerAId: boostedPlayer,
          playerBId: playerBState,
        },
      );
      final expectedResult = ApplyActionResult.success(
        state: boostedState,
        steps: const [],
      );

      when(
        mockCardDrawService.execute(
          boostedState,
          playerAId,
          GameSystemConstants.defaultDrawCount + 1,
        ),
      ).thenReturn(expectedResult);

      final result = cardDrawStartTurnService.execute(boostedState);

      verify(
        mockCardDrawService.execute(
          boostedState,
          playerAId,
          GameSystemConstants.defaultDrawCount + 1,
        ),
      ).called(1);

      expect(result, equals(expectedResult));
    });

    test('drawReductionが基本ドロー数を超えた場合は0枚でCardDrawServiceに委譲される', () {
      final reducedPlayer = playerAState.copyWith(
        debuffs: const [
          DebuffState(debuff: DebuffTypes.drawReduction, stack: 99),
        ],
      );
      final reducedState = baseState.copyWith(
        players: {
          playerAId: reducedPlayer,
          playerBId: playerBState,
        },
      );
      final expectedResult = ApplyActionResult.success(
        state: reducedState,
        steps: const [],
      );

      when(
        mockCardDrawService.execute(
          reducedState,
          playerAId,
          0,
        ),
      ).thenReturn(expectedResult);

      final result = cardDrawStartTurnService.execute(reducedState);

      verify(
        mockCardDrawService.execute(
          reducedState,
          playerAId,
          0,
        ),
      ).called(1);

      expect(result, equals(expectedResult));
    });
  });
}

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
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

@GenerateMocks([CardDrawService])
void main() {
  late MockCardDrawService mockCardDrawService;
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

  const card1 = GameCard(
    instanceId: GameCardInstanceId(value: 'inst_1'),
    definition: cardDef,
    currentCost: 1,
    enteredHandAtTurn: 0,
  );

  final playerAState = PlayerState.create(
    id: playerAId,
    deck: const [card1],
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
    cardDrawStartTurnService = CardDrawStartTurnService(
      cardDrawService: mockCardDrawService,
    );
  });

  group('CardDrawStartTurnService', () {
    test('turnOwnerに対してdefaultDrawCount分のドロー処理がCardDrawServiceに委譲される', () {
      const step = GameStepEvent.valueChanged(
        type: GameStepType.cardsDrawn,
        targetPlayerId: playerAId,
        amount: GameSystemConstants.defaultDrawCount,
      );

      final expectedState = baseState.copyWith(
        players: {
          playerAId: playerAState.copyWith(deck: const [], hand: const [card1]),
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

      expect(result.state, equals(expectedState));
      expect(result.steps, equals([step]));
    });
  });
}

import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_main_phase_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_turn_start_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/switch_turn_owner_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_setup_context.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'game_flow_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TurnPipeline>(),
  MockSpec<GameSetupService>(),
  MockSpec<GameStartDrawCardsService>(),
  MockSpec<RemoveShieldService>(),
  MockSpec<SwitchTurnOwnerService>(),
  MockSpec<CardDrawStartTurnService>(),
  MockSpec<AdvancedToTurnStartService>(),
  MockSpec<CalculateTurnCostService>(),
  MockSpec<AdvanceToMainPhaseService>(),
])
void main() {
  late MockTurnPipeline mockTurnPipeline;
  late MockGameSetupService mockGameSetupService;
  late MockGameStartDrawCardsService mockGameStartDrawCardsService;
  late MockRemoveShieldService mockRemoveShieldService;
  late MockSwitchTurnOwnerService mockSwitchTurnOwnerService;
  late MockCardDrawStartTurnService mockCardDrawStartTurnService;
  late MockAdvancedToTurnStartService mockAdvancedToTurnStartService;
  late MockCalculateTurnCostService mockCalculateTurnCostService;
  late MockAdvanceToMainPhaseService mockAdvanceToMainPhaseService;

  late Player mockPlayer;
  late Player mockEnemy;

  late GameFlowUsecase gameFlowUsecase;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');
  const actionId = GameActionsId(value: 'action_1');
  const cardInstanceId = GameCardInstanceId(value: 'card_inst_1');

  final playerAState = PlayerState.create(id: playerAId, deck: const []);
  final playerBState = PlayerState.create(id: playerBId, deck: const []);

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

    mockTurnPipeline = MockTurnPipeline();
    mockGameSetupService = MockGameSetupService();
    mockGameStartDrawCardsService = MockGameStartDrawCardsService();
    mockRemoveShieldService = MockRemoveShieldService();
    mockSwitchTurnOwnerService = MockSwitchTurnOwnerService();
    mockCardDrawStartTurnService = MockCardDrawStartTurnService();
    mockAdvancedToTurnStartService = MockAdvancedToTurnStartService();
    mockCalculateTurnCostService = MockCalculateTurnCostService();
    mockAdvanceToMainPhaseService = MockAdvanceToMainPhaseService();

    mockPlayer = Player(
      id: PlayerId.generate(),
      name: 'Player A',
      deckRecipe: [],
    );
    mockEnemy = Player(
      id: PlayerId.generate(),
      name: 'Player B',
      deckRecipe: [],
    );

    gameFlowUsecase = GameFlowUsecase(
      turnPipeline: mockTurnPipeline,
      gameSetupService: mockGameSetupService,
      gameStartDrawCardsService: mockGameStartDrawCardsService,
      removeShieldService: mockRemoveShieldService,
      switchTurnOwnerService: mockSwitchTurnOwnerService,
      cardDrawStartTurnService: mockCardDrawStartTurnService,
      advancedToTurnStartService: mockAdvancedToTurnStartService,
      calculateTurnCostService: mockCalculateTurnCostService,
      advanceToMainPhaseService: mockAdvanceToMainPhaseService,
    );
  });

  group('GameFlowUsecase - 基本的な例外・ガード条件のテスト', () {
    test(
      'GameActionGameStartで setupContext が null の場合 ArgumentError をスローすること',
      () {
        expect(
          () => gameFlowUsecase.applyAction(
            current: null,
            action: const GameActions.gameStart(
              id: actionId,
              playerAId: playerAId,
              playerBId: playerBId,
              seed: 12345,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'GameActionGameStart 以外のケースで current が null の場合 StateError をスローすること',
      () {
        expect(
          () => gameFlowUsecase.applyAction(
            current: null,
            action: const GameActions.turnEnd(
              id: actionId,
              playerId: playerAId,
            ),
          ),
          throwsA(isA<StateError>()),
        );
      },
    );
  });

  group('GameFlowUsecase - GameActionGameStart', () {
    test('GameStartアクションが実行された時、GameSetupServiceおよび初期化パイプラインが正しく呼ばれること', () {
      const action = GameActions.gameStart(
        id: actionId,
        playerAId: playerAId,
        playerBId: playerBId,
        seed: 12345,
      );

      final setupContext = GameSetupContext(
        player: mockPlayer,
        enemy: mockEnemy,
        cardDefs: const <CardDefinition>[],
        seed: 12345,
      );

      const setupStep = GameStepEvent.gameStarted(
        type: GameStepType.gameStarted,
        firstTurnPlayerId: playerAId,
      );

      final setupResult = ApplyActionResult(
        state: baseState,
        steps: const [setupStep],
      );

      final expectedPipelineResult = ApplyActionResult(
        state: baseState.copyWith(turnCount: 1),
        steps: const [setupStep],
      );

      when(
        mockGameSetupService.execute(
          playerA: setupContext.player,
          playerB: setupContext.enemy,
          cardDefs: setupContext.cardDefs,
          seed: (action as GameActionGameStart).seed,
        ),
      ).thenReturn(setupResult);

      when(
        mockTurnPipeline.process(
          baseState,
          [setupStep],
          [
            mockGameStartDrawCardsService,
            mockAdvancedToTurnStartService,
            mockCalculateTurnCostService,
            mockAdvanceToMainPhaseService,
          ],
        ),
      ).thenReturn(expectedPipelineResult);

      final result = gameFlowUsecase.applyAction(
        current: null,
        action: action,
        setupContext: setupContext,
      );

      verify(
        mockGameSetupService.execute(
          playerA: setupContext.player,
          playerB: setupContext.enemy,
          cardDefs: setupContext.cardDefs,
          seed: action.seed,
        ),
      ).called(1);

      verify(
        mockTurnPipeline.process(
          baseState,
          [setupStep],
          [
            mockGameStartDrawCardsService,
            mockAdvancedToTurnStartService,
            mockCalculateTurnCostService,
            mockAdvanceToMainPhaseService,
          ],
        ),
      ).called(1);

      expect(result, equals(expectedPipelineResult));
    });
  });

  group('GameFlowUsecase - GameActionTurnEnd', () {
    test('TurnEndアクションが実行された時、ターン終了用パイプラインが正しく組み立てられて実行されること', () {
      const action = GameActions.turnEnd(
        id: actionId,
        playerId: playerAId,
      );

      final expectedPipelineResult = ApplyActionResult(
        state: baseState.nextTurn(),
        steps: const [],
      );

      when(
        mockTurnPipeline.process(
          baseState,
          const [],
          [
            mockSwitchTurnOwnerService,
            mockRemoveShieldService,
            mockCalculateTurnCostService,
            mockCardDrawStartTurnService,
          ],
        ),
      ).thenReturn(expectedPipelineResult);

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      verify(
        mockTurnPipeline.process(
          baseState,
          const [],
          [
            mockSwitchTurnOwnerService,
            mockRemoveShieldService,
            mockCalculateTurnCostService,
            mockCardDrawStartTurnService,
          ],
        ),
      ).called(1);

      expect(result, equals(expectedPipelineResult));
    });
  });

  group('GameFlowUsecase - 未実装/Stubアクション (noSteps)', () {
    test('GameActionPlayCard は Stateの変更がなく empty steps (noSteps) を返すこと', () {
      const action = GameActions.playCard(
        id: actionId,
        playerId: playerAId,
        cardInstanceId: cardInstanceId,
      );

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      expect(result.state, equals(baseState));
      expect(result.steps, isEmpty);
    });

    test('GameActionDiscardCard は Stateの変更がなく empty steps (noSteps) を返すこと', () {
      const action = GameActions.discardCard(
        id: actionId,
        playerId: playerAId,
        cardInstanceId: cardInstanceId,
      );

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      expect(result.state, equals(baseState));
      expect(result.steps, isEmpty);
    });

    test(
      'GameActionSelectOverflowDiscards は Stateの変更がなく empty steps (noSteps) を返すこと',
      () {
        const action = GameActions.selectOverflowDiscards(
          id: actionId,
          playerId: playerAId,
          selectedCardInstanceIds: [cardInstanceId],
        );

        final result = gameFlowUsecase.applyAction(
          current: baseState,
          action: action,
        );

        expect(result.state, equals(baseState));
        expect(result.steps, isEmpty);
      },
    );

    test('GameActionSurrender は Stateの変更がなく empty steps (noSteps) を返すこと', () {
      const action = GameActions.surrender(
        id: actionId,
        playerId: playerAId,
      );

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      expect(result.state, equals(baseState));
      expect(result.steps, isEmpty);
    });
  });
}

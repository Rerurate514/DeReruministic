import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/game_test_helpers.dart';
import 'game_flow_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ITurnPipelineFactory>(),
  MockSpec<TurnPipeline>(),
  MockSpec<GameSetupService>(),
  MockSpec<ApplyPlayCardService>(),
])
void main() {
  late MockITurnPipelineFactory mockPipelineFactory;
  late MockTurnPipeline mockTurnPipeline;
  late MockGameSetupService mockGameSetupService;
  late MockApplyPlayCardService mockApplyPlayCardService;

  late Player mockPlayer;
  late Player mockEnemy;

  late GameFlowUsecase gameFlowUsecase;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');
  const actionId = GameActionsId(value: 'action_1');
  const cardInstanceId = GameCardInstanceId(value: 'card_inst_1');

  final playerAState = PlayerState.create(id: playerAId, deck: const []);
  final playerBState = PlayerState.create(id: playerBId, deck: const []);

  final phase = GamePhase.init(playerAId);
  final baseState = buildState(
    players: {
      playerAId: playerAState,
      playerBId: playerBState,
    },
    battlePhase: phase.battlePhase,
    turnCount: 1,
    turnOwner: playerAId,
    seed: 12345,
  );

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult.success(
        state: baseState,
        steps: const [],
      ),
    );

    mockPipelineFactory = MockITurnPipelineFactory();
    mockTurnPipeline = MockTurnPipeline();
    mockGameSetupService = MockGameSetupService();
    mockApplyPlayCardService = MockApplyPlayCardService();

    mockPlayer = const Player(
      id: playerAId,
      name: 'Player A',
      deckRecipe: [],
    );
    mockEnemy = const Player(
      id: playerBId,
      name: 'Player B',
      deckRecipe: [],
    );

    gameFlowUsecase = GameFlowUsecase(
      pipelineFactory: mockPipelineFactory,
      gameSetupService: mockGameSetupService,
      applyPlayCardService: mockApplyPlayCardService,
      cardCatalog: [],
    );
  });

  group('GameFlowUsecase - 基本的な例外・ガード条件のテスト', () {
    test(
      'GameActionGameStart 以外のケースで current が null の場合 StateError をスローすること',
      () {
        expect(
          () => gameFlowUsecase.applyAction(
            current: null,
            action: const GameActions.turnEnd(
              id: actionId,
              actionSequenceNumber: 2,
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
      final action = GameActions.gameStart(
        id: actionId,
        actionSequenceNumber: 1,
        playerAId: playerAId,
        playerBId: playerBId,
        playerADeckRecipe: mockPlayer.deckRecipe,
        playerBDeckRecipe: mockEnemy.deckRecipe,
        seed: 12345,
      );

      const setupStep = GameStepEvent.gameStarted(
        firstTurnPlayerId: playerAId,
      );

      final setupResult = ApplyActionResult.success(
        state: baseState,
        steps: const [setupStep],
      );

      final expectedPipelineResult = ApplyActionResult.success(
        state: baseState.copyWith(turnCount: 1),
        steps: const [setupStep],
      );

      when(
        mockGameSetupService.execute(
          playerAId: mockPlayer.id,
          playerBId: mockEnemy.id,
          playerADeckRecipe: mockPlayer.deckRecipe,
          playerBDeckRecipe: mockEnemy.deckRecipe,
          cardDefs: const <CardDefinition>[],
          seed: (action as GameActionGameStart).seed,
        ),
      ).thenReturn(setupResult);

      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);

      when(
        mockTurnPipeline.process(
          baseState,
          [setupStep],
        ),
      ).thenReturn(expectedPipelineResult);

      final result = gameFlowUsecase.applyAction(
        current: null,
        action: action,
      );

      verify(
        mockGameSetupService.execute(
          playerAId: mockPlayer.id,
          playerBId: mockEnemy.id,
          playerADeckRecipe: mockPlayer.deckRecipe,
          playerBDeckRecipe: mockEnemy.deckRecipe,
          cardDefs: const <CardDefinition>[],
          seed: action.seed,
        ),
      ).called(1);

      verify(mockPipelineFactory.createGameStartPipeline()).called(1);

      verify(
        mockTurnPipeline.process(
          baseState,
          [setupStep],
        ),
      ).called(1);

      final expectedState = expectedPipelineResult.state
          .incrementalActionSequence();

      expect(
        result,
        ApplyActionResult.success(
          state: expectedState,
          steps: const [setupStep],
        ),
      );
    });
  });

  group('GameFlowUsecase - GameActionTurnEnd', () {
    test('TurnEndアクションが実行された時、ターン終了用パイプラインが正しく取得されて実行されること', () {
      const action = GameActions.turnEnd(
        id: actionId,
        actionSequenceNumber: 2,
        playerId: playerAId,
      );

      final expectedPipelineResult = ApplyActionResult.success(
        state: baseState.nextTurn(),
        steps: const [],
      );

      when(
        mockPipelineFactory.createTurnEndPipeline(),
      ).thenReturn(mockTurnPipeline);

      when(
        mockTurnPipeline.process(
          baseState,
          const [],
        ),
      ).thenReturn(expectedPipelineResult);

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      verify(mockPipelineFactory.createTurnEndPipeline()).called(1);

      verify(
        mockTurnPipeline.process(
          baseState,
          const [],
        ),
      ).called(1);

      final expectedState = expectedPipelineResult.state
          .incrementalActionSequence();

      expect(
        result,
        ApplyActionResult.success(
          state: expectedState,
          steps: const [],
        ),
      );
    });
  });

  group('GameFlowUsecase - 未実装/Stubアクション (noSteps)', () {
    test('GameActionDiscardCard は Stateの変更がなく empty steps (noSteps) を返すこと', () {
      const action = GameActions.discardCard(
        id: actionId,
        actionSequenceNumber: 2,
        playerId: playerAId,
        cardInstanceId: cardInstanceId,
      );

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      final expectedState = baseState.incrementalActionSequence();
      expect(
        result,
        equals(
          ApplyActionResult.success(
            state: expectedState,
            steps: const [],
          ),
        ),
      );
      expect((result as ApplyActionResultSuccess).steps, isEmpty);
    });

    test(
      'GameActionSelectOverflowDiscards は Stateの変更がなく empty steps (noSteps) を返すこと',
      () {
        const action = GameActions.selectOverflowDiscards(
          id: actionId,
          actionSequenceNumber: 2,
          playerId: playerAId,
          selectedCardInstanceIds: [cardInstanceId],
        );

        final result = gameFlowUsecase.applyAction(
          current: baseState,
          action: action,
        );

        final expectedState = baseState.incrementalActionSequence();
        expect(
          result,
          equals(
            ApplyActionResult.success(
              state: expectedState,
              steps: const [],
            ),
          ),
        );
        expect((result as ApplyActionResultSuccess).steps, isEmpty);
      },
    );

    test('GameActionSurrender は Stateの変更がなく empty steps (noSteps) を返すこと', () {
      const action = GameActions.surrender(
        id: actionId,
        actionSequenceNumber: 2,
        playerId: playerAId,
      );

      final result = gameFlowUsecase.applyAction(
        current: baseState,
        action: action,
      );

      final expectedState = baseState.incrementalActionSequence();
      expect(
        result,
        equals(
          ApplyActionResult.success(
            state: expectedState,
            steps: const [],
          ),
        ),
      );
      expect((result as ApplyActionResultSuccess).steps, isEmpty);
    });
  });
}

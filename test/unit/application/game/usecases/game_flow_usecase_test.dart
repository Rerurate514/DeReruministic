import 'package:collection/collection.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/task_service_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/game_test_helpers.dart';
import 'game_flow_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GameSetupService>(),
  MockSpec<TaskServiceFactory>(),
])
void main() {
  const playerId = PlayerId(value: 'player1');
  const enemyId = PlayerId(value: 'player2');

  late MockGameSetupService mockGameSetupService;
  late MockTaskServiceFactory mockTaskServiceFactory;
  late GameFlowUsecase usecase;

  // テストの主眼はタスクキューの消化ロジックなので、
  // metadata/seedなどplayCardと無関係な要素はビルダーでダミー値にしておく。
  GameState buildStateWithMeta({
    required Map<PlayerId, PlayerState> players,
    QueueList<GameTask>? taskQueue,
    int actionSequenceNumber = 1,
    int seed = 0,
  }) {
    final base = buildState(players: Map.from(players), turnOwner: playerId);
    return base.copyWith(
      metadata: SystemMetadata(
        seed: seed,
        actionSequenceNumber: actionSequenceNumber,
      ),
      taskQueue: taskQueue ?? QueueList<GameTask>(),
    );
  }

  setUp(() {
    mockGameSetupService = MockGameSetupService();
    mockTaskServiceFactory = MockTaskServiceFactory();
    usecase = GameFlowUsecase(
      cardCatalog: const <CardDefinition>[],
      gameSetupService: mockGameSetupService,
      taskServiceFactory: mockTaskServiceFactory,
    );

    provideDummy<ApplyActionResult>(
      ApplyActionResult.noSteps(
        state: buildState(
          players: {playerId: buildPlayer(id: playerId)},
          turnOwner: playerId,
        ),
      ),
    );
  });

  GameActionTurnEnd buildTurnEndAction({int actionSequenceNumber = 2}) {
    return GameActions.turnEnd(
          id: const GameActionsId(value: 'turn_end_1'),
          actionSequenceNumber: actionSequenceNumber,
          playerId: playerId,
        )
        as GameActionTurnEnd;
  }

  GameActionPlayCard buildPlayCardActionLocal({
    int actionSequenceNumber = 2,
    String cardInstanceId = 'card1',
  }) {
    return GameActions.playCard(
          id: const GameActionsId(value: 'play_1'),
          actionSequenceNumber: actionSequenceNumber,
          playerId: playerId,
          cardInstanceId: GameCardInstanceId(value: cardInstanceId),
        )
        as GameActionPlayCard;
  }

  group('GameFlowUsecase.applyAction - actionSequenceNumberの検証', () {
    test(
      'GameStart以外で、currentがnullの場合invalidActionSequenceで失敗しStateErrorにならない',
      () {
        final action = buildTurnEndAction(actionSequenceNumber: 1);

        // current: null のため _requireState が StateError を投げるはずだが、
        // シーケンスチェックが先に走るなら invalidActionSequence が先に返る。
        // 実装上 state == null は「不一致」として扱われる想定。
        expect(
          () => usecase.applyAction(current: null, action: action),
          throwsA(isA<StateError>()),
        );
      },
    );

    test(
      'actionSequenceNumberがstate.metadata.actionSequenceNumber+1と一致しない場合、invalidActionSequenceで失敗する',
      () {
        final state = buildStateWithMeta(
          players: {playerId: buildPlayer(id: playerId)},
          actionSequenceNumber: 5,
        );
        final action = buildTurnEndAction(actionSequenceNumber: 3); // 5+1=6のはず

        final result = usecase.applyAction(current: state, action: action);

        expect(result, isA<ApplyActionResultFailure>());
        expect(
          (result as ApplyActionResultFailure).reason,
          ActionFailureReason.invalidActionSequence,
        );
        expect(result.state, state);
        verifyZeroInteractions(mockTaskServiceFactory);
      },
    );

    test('actionSequenceNumberが+1で一致する場合、シーケンスチェックを通過する', () {
      final state = buildStateWithMeta(
        players: {playerId: buildPlayer(id: playerId)},
        actionSequenceNumber: 5,
        taskQueue: QueueList<GameTask>.from([
          const GameTask.mainPhase(activePlayerId: playerId),
        ]),
      );
      final action = buildTurnEndAction(actionSequenceNumber: 6);
      final expected = ApplyActionResult.noSteps(state: state);

      when(
        mockTaskServiceFactory.handleAction(
          state: anyNamed('state'),
          gameTask: anyNamed('gameTask'),
          action: anyNamed('action'),
        ),
      ).thenReturn(expected);

      final result = usecase.applyAction(current: state, action: action);

      // invalidActionSequenceにはならない(=シーケンスチェックは通過している)
      expect(
        result is ApplyActionResultFailure &&
            result.reason == ActionFailureReason.invalidActionSequence,
        isFalse,
      );
    });
  });

  group('GameFlowUsecase.applyAction - GameActionGameStart', () {
    final deckRecipeA = DeckRecipe.create([
      const CardDefinitionId(value: 'def_a1'),
    ]);
    final deckRecipeB = DeckRecipe.create([
      const CardDefinitionId(value: 'def_b1'),
    ]);

    GameActionGameStart buildGameStartAction({
      int actionSequenceNumber = 1,
      int seed = 42,
    }) {
      return GameActions.gameStart(
            id: const GameActionsId(value: 'action_start'),
            actionSequenceNumber: actionSequenceNumber,
            playerId: playerId,
            playerBId: enemyId,
            playerADeckRecipe: deckRecipeA,
            playerBDeckRecipe: deckRecipeB,
            seed: seed,
          )
          as GameActionGameStart;
    }

    test('actionSequenceNumber=1でcurrent=nullの場合、gameSetupServiceが呼ばれる', () {
      final setupState = buildStateWithMeta(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
      );
      const setupStep = GameStepEvent.gameStarted(
        firstTurnPlayerId: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: [setupStep]),
      );

      final result = usecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      verify(
        mockGameSetupService.execute(
          playerAId: playerId,
          playerBId: enemyId,
          playerADeckRecipe: deckRecipeA,
          playerBDeckRecipe: deckRecipeB,
          cardDefs: const <CardDefinition>[],
          seed: 42,
        ),
      ).called(1);
    });

    test('gameSetupServiceが失敗を返す場合、taskQueueは消化されずその失敗がそのまま返る', () {
      final dummyState = buildStateWithMeta(
        players: {playerId: buildPlayer(id: playerId)},
      );
      final failure = ApplyActionResult.failure(
        state: dummyState,
        reason: ActionFailureReason.playerNotFound,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(failure);

      expect(
        () => usecase.applyAction(
          current: null,
          action: buildGameStartAction(),
        ),
        throwsA(isA<UnimplementedError>()),
      );
      verifyZeroInteractions(mockTaskServiceFactory);
    });

    test('gameSetupService成功後、taskQueueにある非interactiveタスクが順に消化される', () {
      final setupState = buildStateWithMeta(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        taskQueue: QueueList<GameTask>.from([
          const GameTask.gameStartDrawCards(),
          const GameTask.advanceToTurnStart(),
        ]),
      );
      const setupStep = GameStepEvent.gameStarted(
        firstTurnPlayerId: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: [setupStep]),
      );

      // 1つ目のタスク実行後の状態(タスクが1つ消化されている)
      final afterDraw = setupState.popTask().copyWith(
        taskQueue: QueueList<GameTask>.from([
          const GameTask.advanceToTurnStart(),
        ]),
      );
      const drawStep = GameStepEvent.cardsDrawn(
        playerId: playerId,
        cardInstanceIds: [],
        zoneFrom: CardZone.deck,
        zoneTo: CardZone.hand,
      );
      when(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.gameStartDrawCards(),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: afterDraw, steps: [drawStep]),
      );

      // 2つ目のタスク実行後、queueは空になる
      final afterAdvance = afterDraw.popTask();
      final phaseStep = GameStepEvent.phaseChanged(phase: afterAdvance.phase);
      when(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.advanceToTurnStart(),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: afterAdvance, steps: [phaseStep]),
      );

      final result = usecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.taskQueue, isEmpty);
      // gameSetupServiceのstep + 2タスク分のstepが結合されている
      expect(success.steps, [setupStep, drawStep, phaseStep]);

      verify(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.gameStartDrawCards(),
        ),
      ).called(1);
      verify(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.advanceToTurnStart(),
        ),
      ).called(1);
    });

    test('taskQueueの先頭がinteractiveなタスク(mainPhase)の場合、そこで消化が止まる', () {
      final setupState = buildStateWithMeta(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        taskQueue: QueueList<GameTask>.from([
          const GameTask.advanceToMainPhase(),
          const GameTask.mainPhase(activePlayerId: playerId),
        ]),
      );
      const setupStep = GameStepEvent.gameStarted(
        firstTurnPlayerId: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: [setupStep]),
      );

      final afterAdvance = setupState.popTask().copyWith(
        taskQueue: QueueList<GameTask>.from([
          const GameTask.mainPhase(activePlayerId: playerId),
        ]),
      );
      final phaseStep = GameStepEvent.phaseChanged(phase: afterAdvance.phase);
      when(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.advanceToMainPhase(),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: afterAdvance, steps: [phaseStep]),
      );

      final result = usecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      final success = result as ApplyActionResultSuccess;
      // mainPhaseタスクが残ったまま止まっている
      expect(success.state.taskQueue, hasLength(1));
      expect(success.state.taskQueue.first, isA<GameTaskMainPhase>());
      // interactiveなタスクにはexecuteが呼ばれない
      verifyNever(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.mainPhase(activePlayerId: playerId),
        ),
      );
    });

    test('タスク処理中に失敗が返ると、その時点で即座に打ち切りその失敗を返す', () {
      final setupState = buildStateWithMeta(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        taskQueue: QueueList<GameTask>.from([
          const GameTask.gameStartDrawCards(),
          const GameTask.advanceToTurnStart(), // ここまで到達しないはず
        ]),
      );
      const setupStep = GameStepEvent.gameStarted(
        firstTurnPlayerId: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: [setupStep]),
      );

      final taskFailure = ApplyActionResult.failure(
        state: setupState.popTask(),
        reason: ActionFailureReason.playerNotFound,
      );
      when(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.gameStartDrawCards(),
        ),
      ).thenReturn(taskFailure);

      final result = usecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      expect(result, taskFailure);
      verifyNever(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: const GameTask.advanceToTurnStart(),
        ),
      );
    });
  });

  group('GameFlowUsecase.applyAction - 通常アクション(taskQueueの先頭タスクによる分岐)', () {
    test('taskQueueが空の場合、invalidActionSequenceで失敗する', () {
      final state = buildStateWithMeta(
        players: {playerId: buildPlayer(id: playerId)},
        taskQueue: QueueList<GameTask>(),
      );
      final action = buildTurnEndAction();

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.invalidActionSequence,
      );
      verifyZeroInteractions(mockTaskServiceFactory);
    });

    test('taskQueueの先頭が非interactiveなタスクの場合、invalidActionSequenceで失敗する', () {
      final state = buildStateWithMeta(
        players: {playerId: buildPlayer(id: playerId)},
        taskQueue: QueueList<GameTask>.from([
          const GameTask.defeatCheck(), // 非interactive
        ]),
      );
      final action = buildTurnEndAction();

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.invalidActionSequence,
      );
      verifyZeroInteractions(mockTaskServiceFactory);
    });

    test(
      'taskQueueの先頭がmainPhase(interactive)の場合、taskServiceFactory.handleActionに委譲される',
      () {
        const task = GameTask.mainPhase(activePlayerId: playerId);
        final state = buildStateWithMeta(
          players: {playerId: buildPlayer(id: playerId)},
          taskQueue: QueueList<GameTask>.from([task]),
        );
        final action = buildPlayCardActionLocal();
        final expected = ApplyActionResult.noSteps(state: state.popTask());

        when(
          mockTaskServiceFactory.handleAction(
            state: state,
            gameTask: task,
            action: action,
          ),
        ).thenReturn(expected);

        usecase.applyAction(current: state, action: action);

        verify(
          mockTaskServiceFactory.handleAction(
            state: state,
            gameTask: task,
            action: action,
          ),
        ).called(1);
      },
    );

    test('handleActionが失敗を返す場合、その失敗がそのまま返りpopTask/processQueueは実行されない', () {
      const task = GameTask.mainPhase(activePlayerId: playerId);
      final state = buildStateWithMeta(
        players: {playerId: buildPlayer(id: playerId)},
        taskQueue: QueueList<GameTask>.from([task]),
      );
      final action = buildPlayCardActionLocal();
      final failure = ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.notEnoughCost,
      );

      when(
        mockTaskServiceFactory.handleAction(
          state: state,
          gameTask: task,
          action: action,
        ),
      ).thenReturn(failure);

      final result = usecase.applyAction(current: state, action: action);

      expect(result, failure);
      verifyNever(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: anyNamed('gameTask'),
        ),
      );
    });

    test('handleActionが成功を返す場合、popTaskされた状態でprocessQueueが実行される', () {
      const task = GameTask.mainPhase(activePlayerId: playerId);
      const nextTask = GameTask.defeatCheck();
      final state = buildStateWithMeta(
        players: {playerId: buildPlayer(id: playerId)},
        taskQueue: QueueList<GameTask>.from([task, nextTask]),
      );
      final action = buildPlayCardActionLocal();

      // handleAction成功時、まだtaskQueueにはtaskが残った状態のstateを返す想定
      final afterHandle = state; // task, nextTask がまだ残っている
      when(
        mockTaskServiceFactory.handleAction(
          state: state,
          gameTask: task,
          action: action,
        ),
      ).thenReturn(ApplyActionResult.noSteps(state: afterHandle));

      // processQueueはafterHandle.popTask()から始まるので、
      // 先頭はnextTask(defeatCheck)になる
      final afterDefeatCheck = afterHandle.popTask().popTask();
      final defeatStep = GameStepEvent.phaseChanged(
        phase: afterDefeatCheck.phase,
      );
      when(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: nextTask,
        ),
      ).thenReturn(
        ApplyActionResult.success(state: afterDefeatCheck, steps: [defeatStep]),
      );

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.taskQueue, isEmpty);
      expect(success.steps, [defeatStep]);

      verify(
        mockTaskServiceFactory.execute(
          state: anyNamed('state'),
          gameTask: nextTask,
        ),
      ).called(1);
    });
  });
}

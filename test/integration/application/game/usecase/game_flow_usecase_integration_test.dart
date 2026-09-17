import 'package:collection/collection.dart';
import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_end_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/interactive_game_task.dart';
import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');
  const strikeId = CardDefinitionId(value: 'strike');
  const guardId = CardDefinitionId(value: 'guard');
  const exhaustStrikeId = CardDefinitionId(value: 'exhaust_strike');
  const expensiveStrikeId = CardDefinitionId(value: 'expensive_strike');
  const lethalStrikeId = CardDefinitionId(value: 'lethal_strike');
  const conditionalTrueStrikeId = CardDefinitionId(
    value: 'conditional_true_strike',
  );
  const conditionalFalseStrikeId = CardDefinitionId(
    value: 'conditional_false_strike',
  );

  const strike = CardDefinition(
    cardDefId: strikeId,
    name: 'Strike',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  );

  const guard = CardDefinition(
    cardDefId: guardId,
    name: 'Guard',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  );

  const exhaustStrike = CardDefinition(
    cardDefId: exhaustStrikeId,
    name: 'Exhaust Strike',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [CardStates.exhaust()],
  );

  const expensiveStrike = CardDefinition(
    cardDefId: expensiveStrikeId,
    name: 'Expensive Strike',
    baseCost: PlayerConstants.defaultInitialCost + 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  );

  const lethalStrike = CardDefinition(
    cardDefId: lethalStrikeId,
    name: 'Lethal Strike',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 25,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  );

  const conditionalTrueStrike = CardDefinition(
    cardDefId: conditionalTrueStrikeId,
    name: 'Conditional Strike',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 5,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHpValueCondition(
          target: CardTargetTypes.enemy,
          value: 50,
          operator: ComparisonOperator.greaterThan,
        ),
      ),
    ],
    states: [],
  );

  const conditionalFalseStrike = CardDefinition(
    cardDefId: conditionalFalseStrikeId,
    name: 'Conditional Strike',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 5,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHpValueCondition(
          target: CardTargetTypes.enemy,
          value: 50,
          operator: ComparisonOperator.lessThan,
        ),
      ),
    ],
    states: [],
  );

  const cardCatalog = [
    strike,
    guard,
    exhaustStrike,
    expensiveStrike,
    lethalStrike,
    conditionalTrueStrike,
    conditionalFalseStrike,
  ];

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        cardCatalogProvider.overrideWithValue(cardCatalog),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  DeckRecipe createDeckRecipe([
    List<CardDefinitionId> cardDefIds = const [strikeId, guardId],
  ]) {
    return DeckRecipe.create(cardDefIds);
  }

  GameActionGameStart createGameStartAction({
    int seed = 42,
    List<CardDefinitionId> playerADeck = const [strikeId, guardId],
    List<CardDefinitionId> playerBDeck = const [strikeId, guardId],
  }) {
    return GameActions.gameStart(
          id: const GameActionsId(value: 'start'),
          actionSequenceNumber: 1,
          playerId: playerAId,
          playerBId: playerBId,
          playerADeckRecipe: createDeckRecipe(playerADeck),
          playerBDeckRecipe: createDeckRecipe(playerBDeck),
          seed: seed,
        )
        as GameActionGameStart;
  }

  ApplyActionResultSuccess startGame(
    GameFlowUsecase usecase, {
    List<CardDefinitionId> playerADeck = const [strikeId, guardId],
    List<CardDefinitionId> playerBDeck = const [strikeId, guardId],
  }) {
    return usecase.applyAction(
          current: null,
          action: createGameStartAction(
            playerADeck: playerADeck,
            playerBDeck: playerBDeck,
          ),
        )
        as ApplyActionResultSuccess;
  }

  void expectMainPhaseTask(ApplyActionResultSuccess success) {
    expect(success.state.taskQueue, hasLength(1));
    expect(success.state.taskQueue.first, isA<GameTaskInteractiveWrapper>());
    expect(
      (success.state.taskQueue.first as GameTaskInteractiveWrapper).task,
      isA<InteractiveGameTaskMainPhase>(),
    );
  }

  ApplyActionResultSuccess applySuccess(
    GameFlowUsecase usecase,
    ApplyActionResultSuccess current,
    GameActions action,
  ) {
    final result = usecase.applyAction(
      current: current.state,
      action: action,
    );

    expect(result, isA<ApplyActionResultSuccess>());
    return result as ApplyActionResultSuccess;
  }

  GameActionsId nextActionId(String prefix, int sequenceNumber) {
    return GameActionsId(value: '${prefix}_$sequenceNumber');
  }

  ApplyActionResultSuccess playAllPossibleCardsOrEndTurn(
    GameFlowUsecase usecase,
    ApplyActionResultSuccess current,
  ) {
    var latest = current;

    while (latest.state.phase.battlePhase != BattlePhase.battleEnd) {
      final currentTask = latest.state.taskQueue.firstOrNull;
      if (currentTask is GameTaskInteractiveWrapper &&
          currentTask.task is InteractiveGameTaskSelectOverflowDiscard) {
        final task =
            currentTask.task as InteractiveGameTaskSelectOverflowDiscard;
        final targetPlayer = latest.state.players[task.targetPlayerId]!;
        final selectedCardIds = targetPlayer.hand
            .take(task.overflowCount)
            .map((card) => card.instanceId)
            .toList();
        final sequenceNumber = latest.state.metadata.actionSequenceNumber + 1;
        latest = applySuccess(
          usecase,
          latest,
          GameActions.selectOverflowDiscards(
            id: nextActionId('overflow_discard', sequenceNumber),
            actionSequenceNumber: sequenceNumber,
            playerId: task.targetPlayerId,
            selectedCardInstanceIds: selectedCardIds,
          ),
        );
        continue;
      }

      final activePlayerId = latest.state.phase.turnOwner;
      final activePlayer = latest.state.players[activePlayerId]!;
      final playableCard = activePlayer.hand.firstWhereOrNull(
        (card) => card.currentCost <= activePlayer.currentCost,
      );

      if (playableCard == null) {
        final sequenceNumber = latest.state.metadata.actionSequenceNumber + 1;
        return applySuccess(
          usecase,
          latest,
          GameActions.turnEnd(
            id: nextActionId('turn_end', sequenceNumber),
            actionSequenceNumber: sequenceNumber,
            playerId: activePlayerId,
          ),
        );
      }

      final sequenceNumber = latest.state.metadata.actionSequenceNumber + 1;
      latest = applySuccess(
        usecase,
        latest,
        GameActions.playCard(
          id: nextActionId('play', sequenceNumber),
          actionSequenceNumber: sequenceNumber,
          playerId: activePlayerId,
          instanceId: playableCard.instanceId,
        ),
      );
    }

    return latest;
  }

  group('GameFlowUsecase 統合テスト', () {
    test('gameStartを適用するとセットアップの自動タスクを処理してメインフェーズで停止する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);

      final result = usecase.applyAction(
        current: null,
        action: createGameStartAction(),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final state = success.state;

      expect(state.players.keys, containsAll([playerAId, playerBId]));
      expect(state.phase.battlePhase, BattlePhase.mainPhase);
      expectMainPhaseTask(success);
      expect(state.players[playerAId]!.hand, hasLength(2));
      expect(state.players[playerBId]!.hand, hasLength(2));
      expect(success.steps.whereType<GameStepEventGameStarted>(), hasLength(1));
      expect(success.steps.whereType<GameStepEventCardsDrawn>(), hasLength(2));
      expect(
        success.steps.whereType<GameStepEventPhaseChanged>().last.phase,
        state.phase,
      );
    });

    test(
      'playCardを適用するとアクティブプレイヤーの手札を消費してダメージを解決する',
      () {
        final usecase = createContainer().read(gameFlowUsecaseProvider);
        final startResult = startGame(usecase);
        final startState = startResult.state;
        final activePlayerId = startState.phase.turnOwner;
        final targetPlayerId = activePlayerId == playerAId
            ? playerBId
            : playerAId;
        final activePlayer = startState.players[activePlayerId]!;
        final card = activePlayer.hand.firstWhere(
          (card) => card.definition.cardDefId == strikeId,
        );

        final result = usecase.applyAction(
          current: startState,
          action: GameActions.playCard(
            id: const GameActionsId(value: 'play_strike'),
            actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
            playerId: activePlayerId,
            instanceId: card.instanceId,
          ),
        );

        expect(result, isA<ApplyActionResultSuccess>());
        final success = result as ApplyActionResultSuccess;
        final state = success.state;
        final updatedActivePlayer = state.players[activePlayerId]!;
        final updatedTargetPlayer = state.players[targetPlayerId]!;

        expect(updatedActivePlayer.hand, isNot(contains(card)));
        expect(updatedActivePlayer.graveyard.map((card) => card.instanceId), [
          card.instanceId,
        ]);
        expect(updatedActivePlayer.currentCost, activePlayer.currentCost - 1);
        expect(updatedTargetPlayer.hp, 97);
        expectMainPhaseTask(success);
        expect(
          success.steps.whereType<GameStepEventCardMovedZone>(),
          hasLength(2),
        );
        expect(
          success.steps.whereType<GameStepEventDamageDealt>().single.hpDamage,
          3,
        );
      },
    );

    test(
      'playCardを適用すると自身へのシールド付与を解決してカードを墓地へ移動する',
      () {
        final usecase = createContainer().read(gameFlowUsecaseProvider);
        final startResult = startGame(usecase);
        final startState = startResult.state;
        final activePlayerId = startState.phase.turnOwner;
        final activePlayer = startState.players[activePlayerId]!;
        final card = activePlayer.hand.firstWhere(
          (card) => card.definition.cardDefId == guardId,
        );

        final result = usecase.applyAction(
          current: startState,
          action: GameActions.playCard(
            id: const GameActionsId(value: 'play_guard'),
            actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
            playerId: activePlayerId,
            instanceId: card.instanceId,
          ),
        );

        expect(result, isA<ApplyActionResultSuccess>());
        final success = result as ApplyActionResultSuccess;
        final updatedPlayer = success.state.players[activePlayerId]!;

        expect(updatedPlayer.shield, 2);
        expect(updatedPlayer.graveyard.map((card) => card.instanceId), [
          card.instanceId,
        ]);
        expect(
          success.steps.whereType<GameStepEventShieldGained>().single.amount,
          2,
        );
        expectMainPhaseTask(success);
      },
    );

    test('playCardを適用すると廃棄カードは墓地ではなく廃棄済みへ移動する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(
        usecase,
        playerADeck: const [exhaustStrikeId, guardId],
        playerBDeck: const [exhaustStrikeId, guardId],
      );
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final targetPlayerId = activePlayerId == playerAId
          ? playerBId
          : playerAId;
      final card = startState.players[activePlayerId]!.hand.firstWhere(
        (card) => card.definition.cardDefId == exhaustStrikeId,
      );

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.playCard(
          id: const GameActionsId(value: 'play_exhaust'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: activePlayerId,
          instanceId: card.instanceId,
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[activePlayerId]!;

      expect(success.state.players[targetPlayerId]!.hp, 96);
      expect(updatedPlayer.graveyard, isEmpty);
      expect(updatedPlayer.exhausted.map((card) => card.instanceId), [
        card.instanceId,
      ]);
      expectMainPhaseTask(success);
    });

    test('条件を満たさないplayCardを適用すると条件付き効果はスキップされる', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(
        usecase,
        playerADeck: const [conditionalFalseStrikeId, guardId],
        playerBDeck: const [conditionalFalseStrikeId, guardId],
      );
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final targetPlayerId = activePlayerId == playerAId
          ? playerBId
          : playerAId;
      final card = startState.players[activePlayerId]!.hand.firstWhere(
        (card) => card.definition.cardDefId == conditionalFalseStrikeId,
      );

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.playCard(
          id: const GameActionsId(value: 'play_condition_false'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: activePlayerId,
          instanceId: card.instanceId,
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;

      expect(success.state.players[targetPlayerId]!.hp, 100);
      expect(success.steps.whereType<GameStepEventDamageDealt>(), isEmpty);
      expect(success.state.players[activePlayerId]!.graveyard, hasLength(1));
      expectMainPhaseTask(success);
    });

    test('条件を満たすplayCardを適用すると条件付き効果が発動する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(
        usecase,
        playerADeck: const [conditionalTrueStrikeId, guardId],
        playerBDeck: const [conditionalTrueStrikeId, guardId],
      );
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final targetPlayerId = activePlayerId == playerAId
          ? playerBId
          : playerAId;
      final card = startState.players[activePlayerId]!.hand.firstWhere(
        (card) => card.definition.cardDefId == conditionalTrueStrikeId,
      );

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.playCard(
          id: const GameActionsId(value: 'play_condition_true'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: activePlayerId,
          instanceId: card.instanceId,
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;

      expect(success.state.players[targetPlayerId]!.hp, 95);
      expect(
        success.steps.whereType<GameStepEventDamageDealt>().single.hpDamage,
        5,
      );
      expectMainPhaseTask(success);
    });

    test('現在コストより高いカードでplayCardを適用すると失敗する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(
        usecase,
        playerADeck: const [expensiveStrikeId, guardId],
        playerBDeck: const [expensiveStrikeId, guardId],
      );
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final targetPlayerId = activePlayerId == playerAId
          ? playerBId
          : playerAId;
      final card = startState.players[activePlayerId]!.hand.firstWhere(
        (card) => card.definition.cardDefId == expensiveStrikeId,
      );

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.playCard(
          id: const GameActionsId(value: 'play_expensive'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: activePlayerId,
          instanceId: card.instanceId,
        ),
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;

      expect(failure.reason, ActionFailureReason.notEnoughCost);
      expect(failure.state.players[activePlayerId]!.hand, contains(card));
      expect(failure.state.players[targetPlayerId]!.hp, 100);
    });

    test('手札にないカードでplayCardを適用すると失敗する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.playCard(
          id: const GameActionsId(value: 'missing_card'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: startState.phase.turnOwner,
          instanceId: const GameCardInstanceId(value: 'missing'),
        ),
      );

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.cardNotFound,
      );
    });

    test('非アクティブプレイヤーがメインフェーズ中にplayCardを適用すると失敗する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final inactivePlayerId = activePlayerId == playerAId
          ? playerBId
          : playerAId;
      final card = startState.players[inactivePlayerId]!.hand.first;

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.playCard(
          id: const GameActionsId(value: 'inactive_play'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: inactivePlayerId,
          instanceId: card.instanceId,
        ),
      );

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.invalidAction,
      );
      expect(result.state, startState);
    });

    test('turnEndを適用すると次プレイヤーのメインフェーズへ進む', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final firstTurnPlayerId = startState.phase.turnOwner;
      final nextTurnPlayerId = firstTurnPlayerId == playerAId
          ? playerBId
          : playerAId;

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.turnEnd(
          id: const GameActionsId(value: 'turn_end'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: firstTurnPlayerId,
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final state = success.state;

      expect(state.phase.turnOwner, nextTurnPlayerId);
      expect(state.phase.battlePhase, BattlePhase.mainPhase);
      expectMainPhaseTask(success);
      expect(
        success.steps
            .whereType<GameStepEventTurnOwnerSwitched>()
            .single
            .newTurnPlayerId,
        nextTurnPlayerId,
      );
      expect(success.steps.whereType<GameStepEventCardsDrawn>(), isEmpty);
    });

    test('非アクティブプレイヤーがturnEndを適用すると失敗する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final inactivePlayerId = activePlayerId == playerAId
          ? playerBId
          : playerAId;

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.turnEnd(
          id: const GameActionsId(value: 'inactive_turn_end'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: inactivePlayerId,
        ),
      );

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.invalidAction,
      );
      expect(result.state, startState);
    });

    test('actionSequenceNumberが一致しないactionを適用するとドメイン処理前に失敗する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);

      final result = usecase.applyAction(
        current: startResult.state,
        action: GameActions.turnEnd(
          id: const GameActionsId(value: 'invalid_sequence'),
          actionSequenceNumber: startResult.state.metadata.actionSequenceNumber,
          playerId: startResult.state.phase.turnOwner,
        ),
      );

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.invalidActionSequence,
      );
      expect(result.state, startResult.state);
    });

    test('selectOverflowDiscardsを適用すると選択した手札が墓地へ移動する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final activePlayer = startState.players[activePlayerId]!;
      final selectedCard = activePlayer.hand.first;
      final overflowState = startState.copyWith(
        taskQueue: QueueList.from([
          GameTask.interactive(
            InteractiveGameTask.selectOverflowDiscard(
              targetPlayerId: activePlayerId,
              overflowCount: 1,
            ),
          ),
        ]),
      );

      final result = usecase.applyAction(
        current: overflowState,
        action: GameActions.selectOverflowDiscards(
          id: const GameActionsId(value: 'select_overflow_discards'),
          actionSequenceNumber: overflowState.metadata.actionSequenceNumber + 1,
          playerId: activePlayerId,
          selectedCardInstanceIds: [selectedCard.instanceId],
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[activePlayerId]!;

      expect(updatedPlayer.hand, isNot(contains(selectedCard)));
      expect(updatedPlayer.graveyard.map((card) => card.instanceId), [
        selectedCard.instanceId,
      ]);
      expect(success.state.taskQueue, isEmpty);
      expect(
        success.steps
            .whereType<GameStepEventCardMovedZone>()
            .single
            .instanceIds,
        [selectedCard.instanceId],
      );
    });

    test('discardCardをメインフェーズで適用すると未実装エラーになる', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final activePlayerId = startState.phase.turnOwner;
      final card = startState.players[activePlayerId]!.hand.first;

      expect(
        () => usecase.applyAction(
          current: startState,
          action: GameActions.discardCard(
            id: const GameActionsId(value: 'discard_card'),
            actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
            playerId: activePlayerId,
            instanceId: card.instanceId,
          ),
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('surrenderをメインフェーズで適用すると相手プレイヤーの勝利でゲームが終了する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final surrenderPlayerId = startState.phase.turnOwner;
      final winnerPlayerId = surrenderPlayerId == playerAId
          ? playerBId
          : playerAId;

      final result = usecase.applyAction(
        current: startState,
        action: GameActions.surrender(
          id: const GameActionsId(value: 'surrender'),
          actionSequenceNumber: startState.metadata.actionSequenceNumber + 1,
          playerId: surrenderPlayerId,
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final state = success.state;
      final gameEnded = success.steps
          .whereType<GameStepEventGameEnded>()
          .single;

      expect(state.phase.battlePhase, BattlePhase.battleEnd);
      expect(gameEnded.endResult, GameEndResult.winnerDecided);
      expect(gameEnded.winnerPlayerId, winnerPlayerId);
      expect(gameEnded.loserPlayerId, surrenderPlayerId);
      expect(gameEnded.reason, DefeatReason.surrender);
    });

    test('ゲーム開始後に双方がカードを使い切るまで行動し、ターンを進めてGameEndまで到達する', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      var current = startGame(
        usecase,
        playerADeck: const [
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
        ],
        playerBDeck: const [
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
          lethalStrikeId,
        ],
      );
      final firstTurnPlayerId = current.state.phase.turnOwner;
      var observedTurnSwitch = false;
      var observedCardPlay = false;
      var observedGameEnd = false;
      var actionCount = 0;

      while (current.state.phase.battlePhase != BattlePhase.battleEnd) {
        current = playAllPossibleCardsOrEndTurn(usecase, current);
        actionCount++;

        observedCardPlay =
            observedCardPlay ||
            current.steps.whereType<GameStepEventCardMovedZone>().isNotEmpty;
        observedTurnSwitch =
            observedTurnSwitch ||
            current.steps
                .whereType<GameStepEventTurnOwnerSwitched>()
                .isNotEmpty;
        observedGameEnd =
            observedGameEnd ||
            current.steps.whereType<GameStepEventGameEnded>().isNotEmpty;

        expect(actionCount, lessThan(100));
      }

      final state = current.state;
      final gameEnded = current.steps
          .whereType<GameStepEventGameEnded>()
          .single;

      expect(observedCardPlay, isTrue);
      expect(observedTurnSwitch, isTrue);
      expect(observedGameEnd, isTrue);
      expect(state.phase.battlePhase, BattlePhase.battleEnd);
      expect(state.turnCount, greaterThan(0));
      expect(state.phase.turnOwner, firstTurnPlayerId);
      expect(gameEnded.endResult, GameEndResult.winnerDecided);
      expect(gameEnded.winnerPlayerId, firstTurnPlayerId);
      expect(gameEnded.reason, DefeatReason.hpZero);
    });

    test('surrenderは手札破棄選択中でも適用されて相手勝利でGameEndになる', () {
      final usecase = createContainer().read(gameFlowUsecaseProvider);
      final startResult = startGame(usecase);
      final startState = startResult.state;
      final surrenderPlayerId = startState.phase.turnOwner;
      final winnerPlayerId = surrenderPlayerId == playerAId
          ? playerBId
          : playerAId;
      final overflowState = startState.copyWith(
        taskQueue: QueueList.from([
          GameTask.interactive(
            InteractiveGameTask.selectOverflowDiscard(
              targetPlayerId: surrenderPlayerId,
              overflowCount: 1,
            ),
          ),
          ...startState.taskQueue,
        ]),
      );

      final result = usecase.applyAction(
        current: overflowState,
        action: GameActions.surrender(
          id: const GameActionsId(value: 'surrender_during_overflow'),
          actionSequenceNumber: overflowState.metadata.actionSequenceNumber + 1,
          playerId: surrenderPlayerId,
        ),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final gameEnded = success.steps
          .whereType<GameStepEventGameEnded>()
          .single;

      expect(success.state.phase.battlePhase, BattlePhase.battleEnd);
      expect(gameEnded.endResult, GameEndResult.winnerDecided);
      expect(gameEnded.winnerPlayerId, winnerPlayerId);
      expect(gameEnded.loserPlayerId, surrenderPlayerId);
      expect(gameEnded.reason, DefeatReason.surrender);
    });
  });
}

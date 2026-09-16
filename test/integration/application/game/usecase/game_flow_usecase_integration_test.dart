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
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
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

  group('GameFlowUsecase integration', () {
    test('gameStart processes setup auto tasks and stops at main phase', () {
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
      'playCard consumes the active player hand card and resolves damage',
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
      'playCard resolves self shield gain and moves the card to graveyard',
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

    test('playCard moves exhaust cards to exhausted instead of graveyard', () {
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

    test('conditional effect is skipped when the condition is not met', () {
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

    test('conditional effect is applied when the condition is met', () {
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

    test('playCard fails when the card cost is higher than current cost', () {
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

    test('playCard fails when the card is not in hand', () {
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

    test('non-active player cannot play a card during main phase', () {
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

    test('turnEnd advances to the next player main phase', () {
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

    test('non-active player cannot end the active player turn', () {
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

    test('action sequence mismatch fails before domain processing', () {
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
  });
}

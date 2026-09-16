import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card_packs/data/basic_pack.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  DeckRecipe createDeckRecipe() {
    return DeckRecipe.create(
      basicPack.map((defs) => defs.cardDefId).take(2).toList(),
    );
  }

  GameActionGameStart createGameStartAction({required int seed}) {
    return GameActions.gameStart(
          id: const GameActionsId(value: 'act_1'),
          actionSequenceNumber: 1,
          playerId: const PlayerId(value: 'player_a'),
          playerBId: const PlayerId(value: 'player_b'),
          playerADeckRecipe: createDeckRecipe(),
          playerBDeckRecipe: createDeckRecipe(),
          seed: seed,
        )
        as GameActionGameStart;
  }

  GameActionTurnEnd createTurnEndAction(GameState state) {
    return GameActions.turnEnd(
          id: const GameActionsId(value: 'act_2'),
          actionSequenceNumber: state.metadata.actionSequenceNumber + 1,
          playerId: state.phase.turnOwner,
        )
        as GameActionTurnEnd;
  }

  group('Event Sourcing Determinism Test', () {
    test('同じActionシーケンスを適用した場合、両者のStateとStep履歴が完全に一致すること', () {
      final containerA = ProviderContainer(
        overrides: [
          cardCatalogProvider.overrideWithValue(basicPack),
        ],
      );
      final containerB = ProviderContainer(
        overrides: [
          cardCatalogProvider.overrideWithValue(basicPack),
        ],
      );

      addTearDown(containerA.dispose);
      addTearDown(containerB.dispose);

      final usecaseA = containerA.read(gameFlowUsecaseProvider);
      final usecaseB = containerB.read(gameFlowUsecaseProvider);

      GameState? stateA;
      GameState? stateB;
      final stepsA = <GameStepEvent>[];
      final stepsB = <GameStepEvent>[];

      final startAction = createGameStartAction(seed: 42);
      for (final action in [startAction]) {
        final resultA = usecaseA.applyAction(current: stateA, action: action);
        stateA = resultA.state;
        stepsA.addAll((resultA as ApplyActionResultSuccess).steps);

        final resultB = usecaseB.applyAction(current: stateB, action: action);
        stateB = resultB.state;
        stepsB.addAll((resultB as ApplyActionResultSuccess).steps);
      }

      final turnEndAction = createTurnEndAction(stateA!);
      final resultA = usecaseA.applyAction(
        current: stateA,
        action: turnEndAction,
      );
      stateA = resultA.state;
      stepsA.addAll((resultA as ApplyActionResultSuccess).steps);

      final resultB = usecaseB.applyAction(
        current: stateB,
        action: turnEndAction,
      );
      stateB = resultB.state;
      stepsB.addAll((resultB as ApplyActionResultSuccess).steps);

      expect(stateA, equals(stateB));
      expect(stepsA, equals(stepsB));
    });

    test('異なるseedを与えた場合、StateまたはStep履歴が異なること', () {
      final containerA = ProviderContainer(
        overrides: [
          cardCatalogProvider.overrideWithValue(basicPack),
        ],
      );
      final containerB = ProviderContainer(
        overrides: [
          cardCatalogProvider.overrideWithValue(basicPack),
        ],
      );
      addTearDown(containerA.dispose);
      addTearDown(containerB.dispose);
      final usecaseA = containerA.read(gameFlowUsecaseProvider);
      final usecaseB = containerB.read(gameFlowUsecaseProvider);

      GameState? stateA;
      GameState? stateB;
      final stepsA = <GameStepEvent>[];
      final stepsB = <GameStepEvent>[];

      final startResultA = usecaseA.applyAction(
        current: null,
        action: createGameStartAction(seed: 42),
      );
      stateA = startResultA.state;
      stepsA.addAll((startResultA as ApplyActionResultSuccess).steps);
      final turnEndResultA = usecaseA.applyAction(
        current: stateA,
        action: createTurnEndAction(stateA),
      );
      stateA = turnEndResultA.state;
      stepsA.addAll((turnEndResultA as ApplyActionResultSuccess).steps);

      final startResultB = usecaseB.applyAction(
        current: null,
        action: createGameStartAction(seed: 12345),
      );
      stateB = startResultB.state;
      stepsB.addAll((startResultB as ApplyActionResultSuccess).steps);
      final turnEndResultB = usecaseB.applyAction(
        current: stateB,
        action: createTurnEndAction(stateB),
      );
      stateB = turnEndResultB.state;
      stepsB.addAll((turnEndResultB as ApplyActionResultSuccess).steps);

      final isSameState = stateA == stateB;
      final isSameSteps = stepsA.toString() == stepsB.toString();
      expect(
        isSameState && isSameSteps,
        isFalse,
        reason:
            'seedが異なるにもかかわらずStateとStepsが完全一致した。'
            '乱数がStateやStepsの生成に反映されていない可能性がある。',
      );
    });

    test('Stepイベント履歴から再構築(リプレイ)した場合、直接適用したStateと一致すること', () {
      final containerA = ProviderContainer(
        overrides: [
          cardCatalogProvider.overrideWithValue(basicPack),
        ],
      );
      final containerReplay = ProviderContainer(
        overrides: [
          cardCatalogProvider.overrideWithValue(basicPack),
        ],
      );
      addTearDown(containerA.dispose);
      addTearDown(containerReplay.dispose);
      final usecaseA = containerA.read(gameFlowUsecaseProvider);
      final usecaseReplay = containerReplay.read(gameFlowUsecaseProvider);

      GameState? stateDirect;
      final allSteps = <GameStepEvent>[];
      final startAction = createGameStartAction(seed: 42);
      final startResult = usecaseA.applyAction(
        current: stateDirect,
        action: startAction,
      );
      stateDirect = startResult.state;
      allSteps.addAll((startResult as ApplyActionResultSuccess).steps);

      final turnEndAction = createTurnEndAction(stateDirect);
      final turnEndResult = usecaseA.applyAction(
        current: stateDirect,
        action: turnEndAction,
      );
      stateDirect = turnEndResult.state;
      allSteps.addAll((turnEndResult as ApplyActionResultSuccess).steps);

      final stateFromReplay = [startAction, turnEndAction].fold<GameState?>(
        null,
        (currentState, action) => usecaseReplay
            .applyAction(
              current: currentState,
              action: action,
            )
            .state,
      );

      expect(
        stateFromReplay,
        equals(stateDirect),
        reason:
            'Stepイベント列だけからStateを再構築した結果が、'
            '直接Actionを適用したStateと一致しない。'
            'Stepsに状態復元に必要な情報が欠落している可能性がある。',
      );
    });
  });
}

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
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

      final actionLogs = <GameActions>[
        const GameActions.gameStart(
          id: GameActionsId(value: 'act_1'),
          actionSequenceNumber: 1,
          playerAId: PlayerId(value: 'player_a'),
          playerBId: PlayerId(value: 'player_b'),
          playerADeckRecipe: [],
          playerBDeckRecipe: [],
          seed: 42,
        ),
        const GameActions.turnEnd(
          id: GameActionsId(value: 'act_2'),
          actionSequenceNumber: 2,
          playerId: PlayerId(value: 'player_a'),
        ),
      ];

      GameState? stateA;
      GameState? stateB;
      final stepsA = <GameStepEvent>[];
      final stepsB = <GameStepEvent>[];

      for (final action in actionLogs) {
        final resultA = usecaseA.applyAction(current: stateA, action: action);
        stateA = resultA.state;
        stepsA.addAll((resultA as ApplyActionResultSuccess).steps);

        final resultB = usecaseB.applyAction(current: stateB, action: action);
        stateB = resultB.state;
        stepsB.addAll((resultB as ApplyActionResultSuccess).steps);
      }

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

      final actionLogsA = <GameActions>[
        const GameActions.gameStart(
          id: GameActionsId(value: 'act_1'),
          actionSequenceNumber: 1,
          playerAId: PlayerId(value: 'player_a'),
          playerBId: PlayerId(value: 'player_b'),
          playerADeckRecipe: [],
          playerBDeckRecipe: [],
          seed: 42,
        ),
        const GameActions.turnEnd(
          id: GameActionsId(value: 'act_2'),
          actionSequenceNumber: 2,
          playerId: PlayerId(value: 'player_a'),
        ),
      ];
      final actionLogsB = <GameActions>[
        const GameActions.gameStart(
          id: GameActionsId(value: 'act_1'),
          actionSequenceNumber: 1,
          playerAId: PlayerId(value: 'player_a'),
          playerBId: PlayerId(value: 'player_b'),
          playerADeckRecipe: [],
          playerBDeckRecipe: [],
          seed: 12345,
        ),
        const GameActions.turnEnd(
          id: GameActionsId(value: 'act_2'),
          actionSequenceNumber: 2,
          playerId: PlayerId(value: 'player_a'),
        ),
      ];

      GameState? stateA;
      GameState? stateB;
      final stepsA = <GameStepEvent>[];
      final stepsB = <GameStepEvent>[];

      for (final action in actionLogsA) {
        final resultA = usecaseA.applyAction(current: stateA, action: action);
        stateA = resultA.state;
        stepsA.addAll((resultA as ApplyActionResultSuccess).steps);
      }
      for (final action in actionLogsB) {
        final resultB = usecaseB.applyAction(current: stateB, action: action);
        stateB = resultB.state;
        stepsB.addAll((resultB as ApplyActionResultSuccess).steps);
      }

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

      final actionLogs = <GameActions>[
        const GameActions.gameStart(
          id: GameActionsId(value: 'act_1'),
          actionSequenceNumber: 1,
          playerAId: PlayerId(value: 'player_a'),
          playerBId: PlayerId(value: 'player_b'),
          playerADeckRecipe: [],
          playerBDeckRecipe: [],
          seed: 42,
        ),
        const GameActions.turnEnd(
          id: GameActionsId(value: 'act_2'),
          actionSequenceNumber: 2,
          playerId: PlayerId(value: 'player_a'),
        ),
      ];

      GameState? stateDirect;
      final allSteps = <GameStepEvent>[];
      for (final action in actionLogs) {
        final result = usecaseA.applyAction(
          current: stateDirect,
          action: action,
        );
        stateDirect = result.state;
        allSteps.addAll((result as ApplyActionResultSuccess).steps);
      }

      final stateFromReplay = actionLogs.fold<GameState?>(
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

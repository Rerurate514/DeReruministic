// ignore_for_all: type=lint

import 'dart:math';

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        cardCatalogProvider.overrideWithValue(basicPack),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GameNotifier Tests', () {
    final dummyPlayer = Player(
      id: PlayerId.generate(),
      name: 'Player 1',
      deckRecipe: const [
        CardDefinitionId(value: 'basic_pack_hit'),
        CardDefinitionId(value: 'basic_pack_defence_stance'),
      ],
    );
    final dummyEnemy = Player(
      id: PlayerId.generate(),
      name: 'Enemy 1',
      deckRecipe: const [
        CardDefinitionId(value: 'basic_pack_hit'),
        CardDefinitionId(value: 'basic_pack_defence_stance'),
      ],
    );

    test('初期状態は null であること', () {
      final gameState = container.read(gameProvider);
      expect(gameState, isNull);
    });

    test('startGame 呼び出し後に GameState が正常に構築され、キューにステップが追加されること', () async {
      await container
          .read(gameProvider.notifier)
          .startGame(
            dummyPlayer,
            dummyEnemy,
            514,
          );

      final state = container.read(gameProvider);

      expect(state, isNotNull);
      expect(state?.players[dummyPlayer.id]!.maxHp, equals(100));
      expect(state?.players[dummyEnemy.id]!.maxHp, equals(100));

      final queue = container.read(stepEventQueueProvider);

      expect(state?.phase.battlePhase, equals(BattlePhase.mainPhase));

      expect(
        queue.any((s) => s.type == GameStepType.cardsDrawn),
        isTrue,
      );
    });

    test('すでにゲームが開始されている場合、再度の startGame 呼び出しは無視されること', () async {
      final notifier = container.read(gameProvider.notifier);

      await notifier.startGame(
        dummyPlayer,
        dummyEnemy,
        514,
      );
      final firstState = container.read(gameProvider);

      await notifier.startGame(
        dummyPlayer,
        dummyEnemy,
        999,
      );
      final secondState = container.read(gameProvider);

      expect(secondState, same(firstState));
    });

    test('state が null の状態で endTurn を実行しても何もしないこと', () async {
      final notifier = container.read(gameProvider.notifier);

      await notifier.endTurn();

      final state = container.read(gameProvider);
      expect(state, isNull);
    });

    test('endTurn 実行時に GameState とキューが正常に更新されること', () async {
      final notifier = container.read(gameProvider.notifier);

      await notifier.startGame(
        dummyPlayer,
        dummyEnemy,
        514,
      );

      await notifier.endTurn();

      final updatedState = container.read(gameProvider)!;

      expect(updatedState.phase.turnOwner, equals(dummyEnemy.id));
      expect(updatedState.turnCount, equals(1));
      expect(updatedState.phase.battlePhase, equals(BattlePhase.mainPhase));
    });

    test('未実装メソッドの呼び出しで例外が発生しないこと', () async {
      final notifier = container.read(gameProvider.notifier);

      expect(
        () => notifier.playCard(
          GameCard(
            instanceId: GameCardInstanceId.generate(Random(0)),
            definition: basicPack.first,
            currentCost: 1,
            enteredHandAtTurn: 1,
          ),
        ),
        returnsNormally,
      );

      expect(
        () => notifier.applyRemoteAction(
          GameActions.turnEnd(
            id: GameActionsId.generate(),
            playerId: dummyPlayer.id,
          ),
        ),
        returnsNormally,
      );

      expect(
        notifier.surrender,
        returnsNormally,
      );
    });
  });
}

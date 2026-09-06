// ignore_for_all: type=lint

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/seed_generator.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/di/providers/core/fiestore_provider.dart';
import 'package:dereruministic/domain/card_packs/data/basic_pack.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../helpers/game_test_helpers.dart';

void main() async {
  final basicPackCardDefIds = DeckRecipe.create(
    basicPack.map((defs) => defs.cardDefId).take(19).toList(),
  );

  late ProviderContainer container;
  late FakeFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirestore = FakeFirebaseFirestore();

    container = ProviderContainer(
      overrides: [
        cardCatalogProvider.overrideWithValue(basicPack),
        seedGeneratorProvider.overrideWithValue(() => 12345),
        firestoreProvider.overrideWithValue(mockFirestore),
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
      deckRecipe: basicPackCardDefIds,
    );
    final dummyEnemy = Player(
      id: PlayerId.generate(),
      name: 'Enemy 1',
      deckRecipe: basicPackCardDefIds,
    );

    test('初期状態は null であること', () {
      final gameState = container.read(gameProvider);
      expect(gameState, isNull);
    });

    test('startGame 呼び出し後に GameState が正常に構築され、キューにステップが追加されること', () async {
      await container
          .read(gameProvider.notifier)
          .startGame(
            buildRoomId(),
            dummyPlayer,
            dummyEnemy,
          );

      final state = container.read(gameProvider);

      expect(state, isNotNull);
      expect(state?.players[dummyPlayer.id]!.maxHp, equals(100));
      expect(state?.players[dummyEnemy.id]!.maxHp, equals(100));

      final queue = container.read(stepEventQueueProvider);

      expect(state?.phase.battlePhase, equals(BattlePhase.mainPhase));

      expect(
        queue.any((s) => s is GameStepEventCardsDrawn),
        isTrue,
      );
    });

    test('すでにゲームが開始されている場合、再度の startGame 呼び出しは無視されること', () async {
      final notifier = container.read(gameProvider.notifier);

      await notifier.startGame(
        buildRoomId(),
        dummyPlayer,
        dummyEnemy,
      );
      final firstState = container.read(gameProvider);

      await notifier.startGame(
        buildRoomId(),
        dummyPlayer,
        dummyEnemy,
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
        buildRoomId(),
        dummyPlayer,
        dummyEnemy,
      );

      final initialState = container.read(gameProvider)!;
      final firstPlayerId = initialState.phase.turnOwner;
      final expectedNextPlayerId = firstPlayerId == dummyPlayer.id
          ? dummyEnemy.id
          : dummyPlayer.id;

      await notifier.endTurn();

      final updatedState = container.read(gameProvider)!;

      expect(updatedState.phase.turnOwner, equals(expectedNextPlayerId));
      expect(updatedState.turnCount, equals(1));
      expect(updatedState.phase.battlePhase, equals(BattlePhase.mainPhase));
    });

    // test(
    //   '9ターン目まで正常に手番交代とターンカウントのインクリメントが継続し、'
    //   '10ターン目でデッキアウトによりゲームが終了すること',
    //   () async {
    //     final notifier = container.read(gameProvider.notifier);

    //     await notifier.startGame(
    //       dummyPlayer,
    //       dummyEnemy,
    //       514,
    //     );

    //     var currentState = container.read(gameProvider)!;
    //     final playerAId = currentState.phase.turnOwner;
    //     final playerBId = playerAId == dummyPlayer.id
    //         ? dummyEnemy.id
    //         : dummyPlayer.id;

    //     var expectedTurn = 1;

    //     for (var i = 1; i <= 9; i++) {
    //       await notifier.endTurn();

    //       currentState = container.read(gameProvider)!;

    //       final expectedOwnerId = i.isOdd ? playerBId : playerAId;
    //       if (currentState.initialTurnOwner == currentState.phase.turnOwner) {
    //         expectedTurn++;
    //       }

    //       expect(currentState.turnCount, equals(expectedTurn));
    //       expect(currentState.phase.turnOwner, equals(expectedOwnerId));
    //       expect(currentState.phase.battlePhase, equals(BattlePhase.mainPhase));
    //     }

    //     await notifier.endTurn();

    //     currentState = container.read(gameProvider)!;

    //     expect(currentState.phase.battlePhase, equals(BattlePhase.battleEnd));

    //     expect(currentState.turnCount, equals(5));
    //     expect(currentState.phase.turnOwner, equals(playerBId));
    //   },
    // );
  });
}

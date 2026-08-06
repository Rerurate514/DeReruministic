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
  final basicPackCardDefIds = <CardDefinitionId>[
    const CardDefinitionId(value: 'basic_pack_hit'),
    const CardDefinitionId(value: 'basic_pack_defence_stance'),
    const CardDefinitionId(value: 'basic_pack_first_aid'),
    const CardDefinitionId(value: 'basic_pack_poisonous_snake_fangs'),
    const CardDefinitionId(value: 'basic_pack_final_below'),
    const CardDefinitionId(value: 'basic_pack_shield_bash'),
    const CardDefinitionId(value: 'basic_pack_meditation'),
    const CardDefinitionId(value: 'naguru'),
    const CardDefinitionId(value: 'basic_pack_purifying_blow'),
    const CardDefinitionId(value: 'basic_pack_energy_steal'),
    const CardDefinitionId(value: 'basic_pack_last_resort'),
    const CardDefinitionId(value: 'basic_pack_accumulation_talisman'),
    const CardDefinitionId(value: 'basic_pack_overloaded_blow'),
    const CardDefinitionId(value: 'basic_pack_time_bomb'),
    const CardDefinitionId(value: 'basic_pack_ominous_curse'),
    const CardDefinitionId(value: 'basic_pack_infinite_blade'),
    const CardDefinitionId(value: 'basic_pack_secretry_stance'),
    const CardDefinitionId(value: 'basic_pack_chain_slash'),
    const CardDefinitionId(value: 'basic_pack_secret_art_corrousion'),
  ];

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

    test(
      '9ターン目まで正常に手番交代とターンカウントのインクリメントが継続し、'
      '10ターン目でデッキアウトによりゲームが終了すること',
      () async {
        final notifier = container.read(gameProvider.notifier);

        await notifier.startGame(
          dummyPlayer,
          dummyEnemy,
          514,
        );

        var currentState = container.read(gameProvider)!;
        final playerAId = currentState.phase.turnOwner;
        final playerBId = playerAId == dummyPlayer.id
            ? dummyEnemy.id
            : dummyPlayer.id;

        for (var expectedTurn = 1; expectedTurn <= 9; expectedTurn++) {
          await notifier.endTurn();

          currentState = container.read(gameProvider)!;

          final expectedOwnerId = expectedTurn.isOdd ? playerBId : playerAId;

          expect(currentState.turnCount, equals(expectedTurn));
          expect(currentState.phase.turnOwner, equals(expectedOwnerId));
          expect(currentState.phase.battlePhase, equals(BattlePhase.mainPhase));
        }

        await notifier.endTurn();

        currentState = container.read(gameProvider)!;

        expect(currentState.phase.battlePhase, equals(BattlePhase.battleEnd));

        expect(currentState.turnCount, equals(9));
        expect(currentState.phase.turnOwner, equals(playerBId));
      },
    );

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

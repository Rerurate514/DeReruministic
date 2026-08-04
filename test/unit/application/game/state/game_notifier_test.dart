// ignore_for_all: type=lint_rule_name

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [cardCatalogProvider.overrideWithValue(basicPack)],
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

    test('initialize 呼び出し後に GameState が正常に構築されること', () {
      container
          .read(gameProvider.notifier)
          .initialize(
            dummyPlayer,
            dummyEnemy,
            seed: 514,
          );

      final state = container.read(gameProvider);

      expect(state, isNotNull);
      expect(state?.player.maxHp, equals(100));
      expect(state?.enemy.maxHp, equals(100));
    });

    test('フェーズ遷移が正常に行われること', () {
      final notifier = container.read(gameProvider.notifier)
        // 1. 初期化
        ..initialize(dummyPlayer, dummyEnemy, seed: 42)
        // 2. ゲーム開始
        ..startGame();

      expect(
        container.read(gameProvider)?.phase.battlePhase,
        equals(BattlePhase.battleStart),
      );

      // 3. ターン開始
      notifier.startTurn();
      expect(
        container.read(gameProvider)?.phase.battlePhase,
        equals(BattlePhase.turnStart),
      );

      // 4. メインフェーズ開始
      notifier.startMainTurn();
      expect(
        container.read(gameProvider)?.phase.battlePhase,
        equals(BattlePhase.main),
      );

      // 5. ターン終了
      notifier.endTurn();
      expect(
        container.read(gameProvider)?.phase.battlePhase,
        equals(BattlePhase.turnEnd),
      );
    });
  });
}

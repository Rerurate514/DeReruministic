import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/services/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/turn_owner.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState? build() {
    return null;
  }

  void initialize(
    Player player,
    Player enemy, {
    int? seed,
    TurnOwner? firstTurn,
  }) {
    final cardDefs = ref.read(cardCatalogProvider);
    final gameSetupService = ref.read(gameSetupServiceProvider);

    state = gameSetupService.execute(
      player: player,
      enemy: enemy,
      cardDefs: cardDefs,
      seed: seed,
    );
  }

  void startGame() {
    if (state == null) return;
  }

  void startTurn() {
    if (state == null) return;
  }

  void playCard(GameCard card) {
    if (state == null) return;
  }

  void endTurn() {
    if (state == null) return;
  }

  void processEnemyTurn() {
    if (state == null) return;
  }

  void checkGameOver() {
    if (state == null) return;
  }
}

import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState? build() {
    return null;
  }

  void startGame() {}
  void startTurn() {}
  void playCard(GameCard card) {}
  void endTurn() {}
  void processEnemyTurn() {}
  void checkGameOver() {}
}

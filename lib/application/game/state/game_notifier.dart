import 'dart:math';

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_action_apply_service.dart';
import 'package:dereruministic/domain/game_system/services/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
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
    final applyService = ref.read(gameActionApplyServiceProvider);

    final action = GameActions.gameStart(
      id: GameActionsId.generate(),
      playerId: player.id,
      seed: seed ?? Random().nextInt(1 << 32),
    );

    state = applyService.applyGameState(
      null,
      action,
      player: player,
      enemy: enemy,
      cardDefs: cardDefs,
    );
  }

  void startGame() {
    final currentState = state;
    if (currentState == null) return;
    state = currentState.copyWith(
      phase: currentState.phase.copyWith(battlePhase: .battleStart),
    );
  }

  void startTurn() {
    final currentState = state;
    if (currentState == null) return;
    state = currentState.copyWith(
      phase: currentState.phase.copyWith(battlePhase: .turnStart),
    );
  }

  void startMainTurn() {
    final currentState = state;
    if (currentState == null) return;
    state = currentState.copyWith(
      phase: currentState.phase.copyWith(battlePhase: .main),
    );
  }

  void playCard(GameCard card) {
    final currentState = state;
    if (currentState == null) return;

    //cardEffectResolveServiceなどでカード効果を適用したGameStateを返す
  }

  void endTurn() {
    final currentState = state;
    if (currentState == null) return;
    state = currentState.copyWith(
      phase: currentState.phase.copyWith(battlePhase: .turnEnd),
    );
  }

  void processEnemyTurn() {
    final currentState = state;
    if (currentState == null) return;
  }

  void checkGameOver() {
    final currentState = state;
    if (currentState == null) return;
  }
}

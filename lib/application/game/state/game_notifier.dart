import 'dart:math';

import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_setup_context.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState? build() {
    return null;
  }

  GameFlowUsecase get _flow => ref.read(gameFlowUsecaseProvider);

  Future<void> _dispatch({
    required GameActions action,
    GameState? base,
    GameSetupContext? setupContext,
  }) async {
    final current = base ?? state;
    if (current == null) return;
    state = _flow.applyAction(
      current: current,
      action: action,
      setupContext: setupContext,
    );
    //await eventSourcingRepository.sendAction(action);
  }

  GameState _buildInitialState({
    required Player player,
    required Player enemy,
    required List<CardDefinition> cardDefs,
    required int seed,
  }) {
    final gameSetupService = ref.read(gameSetupServiceProvider);

    return gameSetupService.execute(
      player: player,
      enemy: enemy,
      cardDefs: cardDefs,
      seed: seed,
    );
  }

  Future<void> startGame(
    Player player,
    Player enemy, {
    int? seed,
  }) async {
    final currentState = state;
    if (currentState != null) return;

    final currentSeed = seed ?? Random().nextInt(1 << 32);

    final initialState = _buildInitialState(
      player: player,
      enemy: enemy,
      cardDefs: ref.read(cardCatalogProvider),
      seed: currentSeed,
    );

    final action = GameActions.gameStart(
      id: GameActionsId.generate(),
      playerId: player.id,
      enemyId: enemy.id,
      seed: currentSeed,
      firstTurn: initialState.phase.owner,
    );

    await _dispatch(action: action, base: initialState);
  }

  void playCard(GameCard card) {
    final currentState = state;
    if (currentState == null) return;

    //cardEffectResolveServiceなどでカード効果を適用したGameStateを返す
  }

  Future<void> endTurn() async {
    final current = state;
    if (current == null) return;
    final action = GameActions.turnEnd(
      id: GameActionsId.generate(),
      playerId: current.currentTurnPlayerId,
    );

    await _dispatch(action: action);
  }

  void applyRemoteAction(GameActions action) {
    final currentState = state;
    if (currentState == null) return;
    //state = gameActionResolveService.apply(currentState, action);
  }

  void checkGameOver() {
    final currentState = state;
    if (currentState == null) return;
  }

  void surrender() {
    final currentState = state;
    if (currentState == null) return;
  }
}

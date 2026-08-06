import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
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
  }) async {
    final current = base ?? state;
    final applyActionResult = _flow.applyAction(
      current: current,
      action: action,
    );

    state = applyActionResult.state;
    ref
        .read(stepEventQueueProvider.notifier)
        .enqueueAll(applyActionResult.steps);
    //await eventSourcingRepository.sendAction(action);
  }

  Future<void> startGame(Player playerA, Player playerB, int seed) async {
    if (state != null) return;

    final action = GameActions.gameStart(
      id: GameActionsId.generate(),
      playerAId: playerA.id,
      playerBId: playerB.id,
      playerADeckRecipe: playerA.deckRecipe,
      playerBDeckRecipe: playerB.deckRecipe,
      seed: seed,
    );

    await _dispatch(
      action: action,
    );
  }

  void playCard(GameCard card) {
    final currentState = state;
    if (currentState == null) return;

    //cardEffectResolveServiceなどでカード効果を適用したGameStateを返す
  }

  Future<void> endTurn() async {
    final current = state;
    if (current == null) return;
    if (current.phase.battlePhase == BattlePhase.battleEnd) return;
    final action = GameActions.turnEnd(
      id: GameActionsId.generate(),
      playerId: current.phase.turnOwner,
    );

    await _dispatch(action: action);
  }

  void applyRemoteAction(GameActions action) {
    final currentState = state;
    if (currentState == null) return;
    //state = gameActionResolveService.apply(currentState, action);
  }

  void surrender() {
    final currentState = state;
    if (currentState == null) return;
  }
}

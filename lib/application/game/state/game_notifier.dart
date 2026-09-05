import 'package:dereruministic/application/game/state/seed_generator.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
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

    if (applyActionResult case ApplyActionResultSuccess(
      :final state,
      :final steps,
    )) {
      this.state = state;
      ref.read(stepEventQueueProvider.notifier).enqueueAll(steps);
      // await eventSourcingRepository.sendAction(action);
    } else if (applyActionResult case ApplyActionResultFailure()) {
      //TODO(error): ERRORハンドリング
    }
  }

  Future<void> startGame(Player playerA, Player playerB) async {
    if (state != null) return;

    final generateSeed = ref.read(seedGeneratorProvider);
    final seed = generateSeed();

    final action = GameActions.gameStart(
      id: GameActionsId.generate(),
      actionSequenceNumber: 1,
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

  Future<void> playCard(GameCard card, PlayerId cardUsedPlayerId) async {
    final currentState = state;
    if (currentState == null) return;

    final action = GameActions.playCard(
      id: GameActionsId.generate(),
      actionSequenceNumber: currentState.metadata.actionSequenceNumber + 1,
      playerId: cardUsedPlayerId,
      cardInstanceId: card.instanceId,
    );

    await _dispatch(action: action);
  }

  Future<void> endTurn() async {
    final currentState = state;
    if (currentState == null) return;
    if (currentState.phase.battlePhase == BattlePhase.battleEnd) return;
    final action = GameActions.turnEnd(
      id: GameActionsId.generate(),
      actionSequenceNumber: currentState.metadata.actionSequenceNumber + 1,
      playerId: currentState.phase.turnOwner,
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

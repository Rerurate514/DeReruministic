import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/task_service_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_flow_usecase.g.dart';

@riverpod
GameFlowUsecase gameFlowUsecase(Ref ref) {
  return GameFlowUsecase(
    cardCatalog: ref.read(cardCatalogProvider),
    gameSetupService: ref.read(gameSetupServiceProvider),
    taskServiceFactory: ref.read(taskServiceFactoryProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.cardCatalog,
    required this.gameSetupService,
    required this.taskServiceFactory,
  });

  final List<CardDefinition> cardCatalog;
  final GameSetupService gameSetupService;

  final TaskServiceFactory taskServiceFactory;

  ApplyActionResult applyAction({
    required GameState? current,
    required GameActions action,
  }) {
    if (!_isValidActionSequenceNumber(action, current) &&
        action is! GameActionGameStart) {
      return ApplyActionResult.failure(
        state: _requireState(current, action),
        reason: ActionFailureReason.invalidActionSequence,
      );
    }

    if (action is GameActionGameStart) return _handleGameStart(action);

    final currentTask = current!.taskQueue.firstOrNull;
    if (currentTask == null) {
      return ApplyActionResult.failure(
        state: current,
        reason: ActionFailureReason.invalidAction,
      );
    }

    switch (currentTask) {
      case GameTaskAutoWrapper():
        return ApplyActionResult.failure(
          state: current,
          reason: ActionFailureReason.invalidAction,
        );
      case GameTaskInteractiveWrapper(:final task):
        {
          final result = taskServiceFactory.handleAction(
            state: current,
            task: task,
            action: action,
          );

          if (result is! ApplyActionResultSuccess) return result;

          return _processQueue(result.state.popTask());
        }
    }
  }

  ApplyActionResult _processQueue(
    GameState state, {
    List<GameStepEvent> steps = const [],
  }) {
    var currentState = state;
    final accumulatedSteps = List<GameStepEvent>.from(steps);

    while (currentState.taskQueue.isNotEmpty) {
      final currentTask = currentState.taskQueue.first;

      switch (currentTask) {
        case GameTaskAutoWrapper(:final task):
          {
            currentState = currentState.popTask();
            final result = taskServiceFactory.executeAutoTask(
              state: currentState,
              task: task,
            );

            if (result is! ApplyActionResultSuccess) return result;

            currentState = result.state;
            accumulatedSteps.addAll(result.steps);
          }
        case GameTaskInteractiveWrapper():
          return ApplyActionResult.success(
            state: currentState,
            steps: accumulatedSteps,
          );
      }
    }

    return ApplyActionResult.success(
      state: currentState,
      steps: accumulatedSteps,
    );
  }

  GameState _requireState(GameState? current, GameActions action) {
    if (current == null) {
      throw StateError('State cannot be null for action: $action');
    }
    return current;
  }

  bool _isValidActionSequenceNumber(
    GameActions action,
    GameState? state,
  ) {
    if (action is GameActionGameStart) {
      return action.actionSequenceNumber == 1;
    }

    if (state == null) return false;

    return state.metadata.actionSequenceNumber + 1 ==
        action.actionSequenceNumber;
  }

  ApplyActionResult _handleGameStart(GameActionGameStart action) {
    final initial = gameSetupService.execute(
      playerAId: action.playerId,
      playerBId: action.playerBId,
      playerADeckRecipe: action.playerADeckRecipe,
      playerBDeckRecipe: action.playerBDeckRecipe,
      cardDefs: cardCatalog,
      seed: action.seed,
    );

    return switch (initial) {
      ApplyActionResultSuccess(:final state, :final steps) => _processQueue(
        state,
        steps: steps,
      ),
      final ApplyActionResultFailure failure => failure,
    };
  }
}

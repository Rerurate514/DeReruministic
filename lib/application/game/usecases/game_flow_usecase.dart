import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_setup_context.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_flow_usecase.g.dart';

@riverpod
GameFlowUsecase gameFlowUsecase(Ref ref) {
  return GameFlowUsecase(
    pipelineFactory: ref.read(turnPipelineFactoryProvider),
    gameSetupService: ref.read(gameSetupServiceProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.pipelineFactory,
    required this.gameSetupService,
  });

  final ITurnPipelineFactory pipelineFactory;
  final GameSetupService gameSetupService;

  ApplyActionResult applyAction({
    required GameState? current,
    required GameActions action,
    GameSetupContext? setupContext,
  }) {
    if (action is GameActionGameStart) {
      if (setupContext == null) {
        throw ArgumentError('setupContext is required for GameStart');
      }
      return _applyGameStart(action, setupContext);
    }

    if (current == null) {
      throw StateError('State cannot be null for action: $action');
    }

    final steps = <GameStepEvent>[];
    switch (action) {
      case GameActionPlayCard():
        return _applyPlayCard(current, action);
      case GameActionDiscardCard():
        return _applyDiscardCard(current, action);
      case GameActionSelectOverflowDiscards():
        return _applyOverflowDiscards(current, action);
      case GameActionTurnEnd():
        return _applyTurnEndAndAutoAdvance(current, action, steps);
      case GameActionSurrender():
        return _applySurrender(current, action);
      case GameActionGameStart():
        throw ArgumentError('setupContext is required for GameStart');
    }
  }

  ApplyActionResult _applyGameStart(
    GameActionGameStart action,
    GameSetupContext context,
  ) {
    final initialState = gameSetupService.execute(
      playerA: context.player,
      playerB: context.enemy,
      cardDefs: context.cardDefs,
      seed: action.seed,
    );

    final pipeline = pipelineFactory.createGameStartPipeline();
    return pipeline.process(initialState.state, initialState.steps);
  }

  ApplyActionResult _applyPlayCard(
    GameState current,
    GameActionPlayCard action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }

  ApplyActionResult _applyDiscardCard(
    GameState current,
    GameActionDiscardCard action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }

  ApplyActionResult _applyOverflowDiscards(
    GameState current,
    GameActionSelectOverflowDiscards action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }

  ApplyActionResult _applyTurnEndAndAutoAdvance(
    GameState current,
    GameActionTurnEnd action,
    List<GameStepEvent> initialSteps,
  ) {
    if (current.phase.battlePhase == BattlePhase.battleEnd) {
      return ApplyActionResult.noSteps(state: current);
    }

    final pipeline = pipelineFactory.createTurnEndPipeline();
    return pipeline.process(current, initialSteps);
  }

  ApplyActionResult _applySurrender(
    GameState current,
    GameActionSurrender action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }
}

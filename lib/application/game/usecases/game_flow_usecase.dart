import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_flow_usecase.g.dart';

@riverpod
GameFlowUsecase gameFlowUsecase(Ref ref) {
  return GameFlowUsecase(
    cardCatalog: ref.read(cardCatalogProvider),
    pipelineFactory: ref.read(turnPipelineFactoryProvider),
    gameSetupService: ref.read(gameSetupServiceProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.cardCatalog,
    required this.pipelineFactory,
    required this.gameSetupService,
  });

  final List<CardDefinition> cardCatalog;
  final ITurnPipelineFactory pipelineFactory;
  final GameSetupService gameSetupService;

  ApplyActionResult applyAction({
    required GameState? current,
    required GameActions action,
  }) {
    return switch (action) {
      GameActionGameStart() => _applyGameStart(action),
      GameActionPlayCard() => _applyPlayCard(
        _requireState(current, action),
        action,
      ),
      GameActionDiscardCard() => _applyDiscardCard(
        _requireState(current, action),
        action,
      ),
      GameActionSelectOverflowDiscards() => _applyOverflowDiscards(
        _requireState(current, action),
        action,
      ),
      GameActionTurnEnd() => _applyTurnEndAndAutoAdvance(
        _requireState(current, action),
        action,
      ),
      GameActionSurrender() => _applySurrender(
        _requireState(current, action),
        action,
      ),
    };
  }

  GameState _requireState(GameState? current, GameActions action) {
    if (current == null) {
      throw StateError('State cannot be null for action: $action');
    }
    return current;
  }

  ApplyActionResult _applyGameStart(
    GameActionGameStart action,
  ) {
    final initial = gameSetupService.execute(
      playerAId: action.playerAId,
      playerBId: action.playerBId,
      playerADeckRecipe: action.playerADeckRecipe,
      playerBDeckRecipe: action.playerBDeckRecipe,
      cardDefs: cardCatalog,
      seed: action.seed,
    );

    final pipeline = pipelineFactory.createGameStartPipeline();

    if (initial case ApplyActionResultFailure()) {
      return initial;
    }

    return pipeline.process(
      initial.state,
      (initial as ApplyActionResultSuccess).steps,
    );
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
  ) {
    if (current.phase.battlePhase == BattlePhase.battleEnd) {
      return ApplyActionResult.noSteps(state: current);
    }

    final pipeline = pipelineFactory.createTurnEndPipeline();
    return pipeline.process(current, []);
  }

  ApplyActionResult _applySurrender(
    GameState current,
    GameActionSurrender action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }
}

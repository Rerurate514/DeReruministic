import 'package:dereruministic/application/card/state/card_catalog_provider.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
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
    applyPlayCardService: ref.read(applyPlayCardServiceProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.cardCatalog,
    required this.pipelineFactory,
    required this.gameSetupService,
    required this.applyPlayCardService,
  });

  final List<CardDefinition> cardCatalog;
  final ITurnPipelineFactory pipelineFactory;
  final GameSetupService gameSetupService;
  final ApplyPlayCardService applyPlayCardService;

  ApplyActionResult applyAction({
    required GameState? current,
    required GameActions action,
  }) {
    if (!_isValidActionSequenceNumber(action, current) &&
        action is! GameActionGameStart) {
      return ApplyActionResult.failure(
        state: current!,
        reason: ActionFailureReason.invalidActionSequence,
      );
    }

    final result = _dispatchAction(current, action);

    return switch (result) {
      ApplyActionResultSuccess(:final state, :final steps) =>
        ApplyActionResult.success(
          state: state.incrementalActionSequence(),
          steps: steps,
        ),
      ApplyActionResultFailure() => result,
    };
  }

  ApplyActionResult _dispatchAction(GameState? current, GameActions action) {
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

    if (!_isValidActionSequenceNumber(action, initial.state)) {
      return ApplyActionResult.failure(
        state: initial.state,
        reason: ActionFailureReason.invalidActionSequence,
      );
    }

    final pipeline = pipelineFactory.createGameStartPipeline();

    if (initial case ApplyActionResultFailure()) {
      return initial;
    }

    return pipeline.process(initial.state, []);
  }

  ApplyActionResult _applyPlayCard(
    GameState state,
    GameActionPlayCard action,
  ) {
    final applyResult = applyPlayCardService.execute(
      state: state,
      action: action,
    );

    return applyResult;
  }

  ApplyActionResult _applyDiscardCard(
    GameState state,
    GameActionDiscardCard action,
  ) {
    //TODO(action): add
    return ApplyActionResult.noSteps(state: state);
  }

  ApplyActionResult _applyOverflowDiscards(
    GameState state,
    GameActionSelectOverflowDiscards action,
  ) {
    //TODO(action): add
    return ApplyActionResult.noSteps(state: state);
  }

  ApplyActionResult _applyTurnEndAndAutoAdvance(
    GameState state,
    GameActionTurnEnd action,
  ) {
    if (state.phase.battlePhase == BattlePhase.battleEnd) {
      return ApplyActionResult.noSteps(state: state);
    }

    final pipeline = pipelineFactory.createTurnEndPipeline();
    return pipeline.process(state, []);
  }

  ApplyActionResult _applySurrender(
    GameState state,
    GameActionSurrender action,
  ) {
    //TODO(action): add
    return ApplyActionResult.noSteps(state: state);
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
}

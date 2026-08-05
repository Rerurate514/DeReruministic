import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_turn_start_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/switch_turn_owner_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_setup_context.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_flow_usecase.g.dart';

@riverpod
GameFlowUsecase gameFlowUsecase(Ref ref) {
  return GameFlowUsecase(
    turnPipeline: ref.read(turnPipelineProvider),
    gameSetupService: ref.read(gameSetupServiceProvider),
    gameStartDrawCardsService: ref.read(gameStartDrawCardsServiceProvider),
    removeShieldService: ref.read(removeShieldServiceProvider),
    switchTurnOwnerService: ref.read(switchTurnOwnerServiceProvider),
    calculateTurnCostService: ref.read(calculateTurnCostServiceProvider),
    cardDrawStartTurnService: ref.read(cardDrawStartTurnServiceProvider),
    advancedToTurnStartService: ref.read(advancedToTurnStartServiceProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.advancedToTurnStartService,
    required this.cardDrawStartTurnService,
    required this.calculateTurnCostService,
    required this.switchTurnOwnerService,
    required this.removeShieldService,
    required this.gameStartDrawCardsService,
    required this.gameSetupService,
    required this.turnPipeline,
  });

  final TurnPipeline turnPipeline;
  final GameSetupService gameSetupService;
  final GameStartDrawCardsService gameStartDrawCardsService;
  final RemoveShieldService removeShieldService;
  final SwitchTurnOwnerService switchTurnOwnerService;
  final CalculateTurnCostService calculateTurnCostService;
  final CardDrawStartTurnService cardDrawStartTurnService;
  final AdvancedToTurnStartService advancedToTurnStartService;

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

    return turnPipeline.process(initialState.state, initialState.steps, [
      gameStartDrawCardsService,
      advancedToTurnStartService,
      calculateTurnCostService,
      
    ]);
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
    return turnPipeline.process(
      current,
      initialSteps,
      [
        //　ターン終了フェーズ（現プレイヤー）カード状態更新
        // updateCardCountersService,
        // resolveTimedCardEffectsService,
        // resolveTurnEndStatusService,
        // processRottenCardExhaustService,

        //　ターン終了フェーズ（現プレイヤー）バフデバフ更新
        // resolveTurnEndStatusService,
        // triggerOnTurnEndEventService,

        // 手番交代
        switchTurnOwnerService,

        // ターン開始フェーズ（新プレイヤー）
        removeShieldService,
        // resolveRegenService,
        // resolvePoisonService,
        // checkDeathService,
        calculateTurnCostService,
        // applyGuardBoostService,
        // resetComboService,
        // triggerOnTurnStartEventService,

        // ドローフェーズ
        cardDrawStartTurnService,
        // checkHandLimitService,
      ],
    );
  }

  ApplyActionResult _applySurrender(
    GameState current,
    GameActionSurrender action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }
}

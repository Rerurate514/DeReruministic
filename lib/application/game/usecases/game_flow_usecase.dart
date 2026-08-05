import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/switch_turn_owner_service.dart';
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
    removeShieldService: ref.read(removeShieldServiceProvider),
    switchTurnOwnerService: ref.read(switchTurnOwnerServiceProvider),
    calculateTurnCostService: ref.read(calculateTurnCostServiceProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.calculateTurnCostService,
    required this.switchTurnOwnerService,
    required this.removeShieldService,
    required this.gameSetupService,
    required this.turnPipeline,
  });

  final TurnPipeline turnPipeline;
  final GameSetupService gameSetupService;
  final RemoveShieldService removeShieldService;
  final SwitchTurnOwnerService switchTurnOwnerService;
  final CalculateTurnCostService calculateTurnCostService;

  ApplyActionResult applyAction({
    required GameState current,
    required GameActions action,
    GameSetupContext? setupContext,
  }) {
    final steps = <GameStepEvent>[];
    switch (action) {
      case GameActionGameStart():
        {
          if (setupContext == null) throw ArgumentError();
          return _applyGameStart(current, action, setupContext);
        }
      case GameActionPlayCard():
        return _applyPlayCard(current, action);
      case GameActionDiscardCard():
        return _applyDiscardCard(current, action);
      case GameActionSelectOverflowDiscards():
        return _applyOverflowDiscards(
          current,
          action,
        );
      case GameActionTurnEnd():
        return _applyTurnEndAndAutoAdvance(current, action, steps);
      case GameActionSurrender():
        return _applySurrender(current, action);
    }
  }

  ApplyActionResult _applyGameStart(
    GameState current,
    GameActionGameStart action,
    GameSetupContext context,
  ) {
    return ApplyActionResult.noSteps(
      state: gameSetupService.execute(
        playerA: context.player,
        playerB: context.enemy,
        cardDefs: context.cardDefs,
        seed: context.seed,
      ),
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
        // cardDrawService,
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

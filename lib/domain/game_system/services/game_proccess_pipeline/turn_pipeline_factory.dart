// domain/game_system/services/turn_pipeline_factory.dart

import 'package:dereruministic/domain/game_system/services/flows/common/defeat_check_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_main_phase_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_turn_start_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/switch_turn_owner_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/turn_end_phase_changed_event_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/update_card_counter_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'turn_pipeline_factory.g.dart';

@riverpod
TurnPipelineFactory turnPipelineFactory(Ref ref) {
  return TurnPipelineFactory(
    turnEndPhaseChangedEventService: ref.read(
      turnEndPhaseChangedEventServiceProvider,
    ),
    updateCardCounterService: ref.read(updateCardCounterServiceProvider),
    defeatCheckService: ref.read(defeatCheckServiceProvider),
    gameStartDrawCardsService: ref.read(gameStartDrawCardsServiceProvider),
    advancedToTurnStartService: ref.read(advancedToTurnStartServiceProvider),
    calculateTurnCostService: ref.read(calculateTurnCostServiceProvider),
    advanceToMainPhaseService: ref.read(advanceToMainPhaseServiceProvider),
    switchTurnOwnerService: ref.read(switchTurnOwnerServiceProvider),
    removeShieldService: ref.read(removeShieldServiceProvider),
    cardDrawStartTurnService: ref.read(cardDrawStartTurnServiceProvider),
  );
}

class TurnPipelineFactory implements ITurnPipelineFactory {
  const TurnPipelineFactory({
    required this.turnEndPhaseChangedEventService,
    required this.updateCardCounterService,
    required this.defeatCheckService,
    required this.gameStartDrawCardsService,
    required this.advancedToTurnStartService,
    required this.calculateTurnCostService,
    required this.advanceToMainPhaseService,
    required this.switchTurnOwnerService,
    required this.removeShieldService,
    required this.cardDrawStartTurnService,
  });

  final TurnEndPhaseChangedEventService turnEndPhaseChangedEventService;
  final UpdateCardCounterService updateCardCounterService;
  final DefeatCheckService defeatCheckService;
  final GameStartDrawCardsService gameStartDrawCardsService;
  final AdvancedToTurnStartService advancedToTurnStartService;
  final CalculateTurnCostService calculateTurnCostService;
  final AdvanceToMainPhaseService advanceToMainPhaseService;
  final SwitchTurnOwnerService switchTurnOwnerService;
  final RemoveShieldService removeShieldService;
  final CardDrawStartTurnService cardDrawStartTurnService;

  @override
  TurnPipeline createGameStartPipeline() {
    return TurnPipeline(
      turnProcessSteps: [
        gameStartDrawCardsService,
        advancedToTurnStartService,
        calculateTurnCostService,
        advanceToMainPhaseService,
      ],
    );
  }

  @override
  TurnPipeline createTurnEndPipeline() {
    return TurnPipeline(
      turnProcessSteps: [
        //　ターン終了フェーズ（現プレイヤー）カード状態更新
        turnEndPhaseChangedEventService,
        updateCardCounterService,
        // resolveTimedCardEffectsService,
        // resolveTurnEndStatusService,
        // processRottenCardExhaustService,

        //　ターン終了フェーズ（現プレイヤー）バフデバフ更新
        // resolveTurnEndStatusService,
        // triggerOnTurnEndEventService,
        defeatCheckService,

        // 手番交代
        switchTurnOwnerService,

        // ターン開始フェーズ（新プレイヤー）
        removeShieldService,
        // resolveRegenService,
        // resolvePoisonService,
        defeatCheckService,
        calculateTurnCostService,

        // applyGuardBoostService,
        // resetComboService,
        // triggerOnTurnStartEventService,

        // ドローフェーズ
        defeatCheckService,
        cardDrawStartTurnService,
        // checkHandLimitService,

        // メインフェーズ
        advanceToMainPhaseService,
      ],
    );
  }
}

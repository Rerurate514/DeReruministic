// domain/game_system/services/turn_pipeline_factory.dart

import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_main_phase_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_turn_start_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/switch_turn_owner_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'turn_pipeline_factory.g.dart';

@riverpod
TurnPipelineFactory turnPipelineFactory(Ref ref) {
  return TurnPipelineFactory(
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
    required GameStartDrawCardsService gameStartDrawCardsService,
    required AdvancedToTurnStartService advancedToTurnStartService,
    required CalculateTurnCostService calculateTurnCostService,
    required AdvanceToMainPhaseService advanceToMainPhaseService,
    required SwitchTurnOwnerService switchTurnOwnerService,
    required RemoveShieldService removeShieldService,
    required CardDrawStartTurnService cardDrawStartTurnService,
  }) : _gameStartDrawCardsService = gameStartDrawCardsService,
       _advancedToTurnStartService = advancedToTurnStartService,
       _calculateTurnCostService = calculateTurnCostService,
       _advanceToMainPhaseService = advanceToMainPhaseService,
       _switchTurnOwnerService = switchTurnOwnerService,
       _removeShieldService = removeShieldService,
       _cardDrawStartTurnService = cardDrawStartTurnService;
  final GameStartDrawCardsService _gameStartDrawCardsService;
  final AdvancedToTurnStartService _advancedToTurnStartService;
  final CalculateTurnCostService _calculateTurnCostService;
  final AdvanceToMainPhaseService _advanceToMainPhaseService;
  final SwitchTurnOwnerService _switchTurnOwnerService;
  final RemoveShieldService _removeShieldService;
  final CardDrawStartTurnService _cardDrawStartTurnService;

  @override
  TurnPipeline createGameStartPipeline() {
    return TurnPipeline(
      turnProcessSteps: [
        _gameStartDrawCardsService,
        _advancedToTurnStartService,
        _calculateTurnCostService,
        _advanceToMainPhaseService,
      ],
    );
  }

  @override
  TurnPipeline createTurnEndPipeline() {
    return TurnPipeline(
      turnProcessSteps: [
        //　ターン終了フェーズ（現プレイヤー）カード状態更新
        // updateCardCountersService,
        // resolveTimedCardEffectsService,
        // resolveTurnEndStatusService,
        // processRottenCardExhaustService,

        //　ターン終了フェーズ（現プレイヤー）バフデバフ更新
        // resolveTurnEndStatusService,
        // triggerOnTurnEndEventService,

        // 手番交代
        _switchTurnOwnerService,

        // ターン開始フェーズ（新プレイヤー）
        _removeShieldService,
        // resolveRegenService,
        // resolvePoisonService,
        // checkDeathService,
        _calculateTurnCostService,
        // applyGuardBoostService,
        // resetComboService,
        // triggerOnTurnStartEventService,

        // ドローフェーズ
        _cardDrawStartTurnService,
        // checkHandLimitService,

        // メインフェーズ
        _advanceToMainPhaseService,
      ],
    );
  }
}

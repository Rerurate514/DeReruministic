import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/common/defeat_check_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_main_phase_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_turn_start_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/card_draw_start_turn_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/check_hand_limit_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/switch_turn_owner_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/turn_end_phase_changed_event_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/update_card_counter_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/tasks_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_service_factory.g.dart';

@riverpod
TaskServiceFactory taskServiceFactory(Ref ref) {
  return TaskServiceFactory(
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
    checkHandLimitService: ref.read(checkHandLimitServiceProvider),
    applyPlayCardService: ref.read(applyPlayCardServiceProvider),
  );
}

class TaskServiceFactory {
  const TaskServiceFactory({
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
    required this.checkHandLimitService,
    required this.applyPlayCardService,
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
  final CheckHandLimitService checkHandLimitService;
  final ApplyPlayCardService applyPlayCardService;

  ApplyActionResult execute({
    required GameState state,
    required GameTask gameTask,
  }) => switch (gameTask) {
    GameTaskGameStartDrawCards() => gameStartDrawCardsService.execute(
      state,
    ),
    GameTaskAdvanceToTurnStart() => advancedToTurnStartService.execute(
      state,
    ),
    GameTaskCalculateCost() => calculateTurnCostService.execute(
      state,
    ),
    GameTaskAdvanceToMainPhase() => advanceToMainPhaseService.execute(
      state,
    ),
    GameTaskTurnEndPhaseChanged() => turnEndPhaseChangedEventService.execute(
      state,
    ),
    GameTaskUpdateCardCounter() => updateCardCounterService.execute(
      state,
    ),
    GameTaskDefeatCheck() => defeatCheckService.execute(
      state,
    ),
    GameTaskSwitchTurnOwner() => switchTurnOwnerService.execute(
      state,
    ),
    GameTaskRemoveShield() => removeShieldService.execute(
      state,
    ),
    GameTaskCardDraw() => cardDrawStartTurnService.execute(
      state,
    ),
    GameTaskCheckHandLimit() => checkHandLimitService.execute(
      state,
    ),
    GameTaskMainPhase() => throw UnimplementedError(
      'Service for GameTaskMainPhase is not registered.',
    ),
    GameTaskSelectOverflowDiscard() => throw UnimplementedError(
      'Service for GameTaskSelectOverflowDiscard is not registered.',
    ),
  };

  ApplyActionResult handleAction({
    required GameState state,
    required GameTask gameTask,
    required GameActions action,
  }) => switch (gameTask) {
    GameTaskSelectOverflowDiscard() => () {
      if (action is! GameActionSelectOverflowDiscards) {
        return ApplyActionResult.failure(
          state: state,
          reason: ActionFailureReason.invalidActionSequence,
        );
      }
      //return applyDiscardService.execute(state, action);
      return ApplyActionResult.noSteps(state: state);
    }(),

    GameTaskMainPhase(:final activePlayerId) => () {
      if (action is! GameActionSurrender && action.playerId != activePlayerId) {
        return ApplyActionResult.failure(
          state: state,
          reason: ActionFailureReason.invalidAction,
        );
      }

      return switch (action) {
        GameActionPlayCard() => applyPlayCardService.execute(
          state: state,
          action: action,
        ),
        // GameActionDiscardCard() => discardCardService.execute(state, action),
        // GameActionSurrender() => surrenderService.execute(state, action),
        GameActionDiscardCard() => throw UnimplementedError(),
        GameActionSurrender() => throw UnimplementedError(),
        GameActionTurnEnd() => _handleTurnEndAction(state),
        _ => ApplyActionResult.failure(
          state: state,
          reason: ActionFailureReason.invalidActionSequence,
        ),
      };
    }(),

    _ => ApplyActionResult.failure(
      state: state,
      reason: ActionFailureReason.invalidActionSequence,
    ),
  };

  ApplyActionResult _handleTurnEndAction(GameState state) {
    final stateWithTasks = state.popTask().pushTasks(
      GameStateTaskPushPos.head,
      TasksFactory.turnEndTasks,
    );

    return ApplyActionResult.noSteps(state: stateWithTasks);
  }
}

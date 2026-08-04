import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_action_apply_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';

class GameFlowUsecase {
  const GameFlowUsecase({required this.gameActionApplyService});

  final GameActionApplyService gameActionApplyService;

  GameState applyAction(GameState current, GameActions action) {
    return switch (action) {
      GameActions.gameStart() => _applyGameStart(current, action),
      GameActions.playCard() => _applyPlayCard(current, action),
      GameActions.discardCard() => _applyDiscardCard(current, action),
      GameActions.selectOverflowDiscards() => _applyOverflowDiscards(
        current,
        action,
      ),
      GameActions.turnEnd() => _applyTurnEndAndAutoAdvance(current, action),
      GameActions.surrender() => _applySurrender(current, action),
    };
  }
}

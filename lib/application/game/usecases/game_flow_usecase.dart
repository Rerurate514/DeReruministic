import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_setup_context.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_flow_usecase.g.dart';

@riverpod
GameFlowUsecase gameFlowUsecase(Ref ref) {
  return GameFlowUsecase(gameSetupService: ref.read(gameSetupServiceProvider));
}

class GameFlowUsecase {
  const GameFlowUsecase({required this.gameSetupService});

  final GameSetupService gameSetupService;

  GameState applyAction({
    required GameState current,
    required GameActions action,
    GameSetupContext? setupContext,
  }) {
    switch (action) {
      case GameActionGameStart():
        return _applyGameStart(current, action, setupContext!);
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
        return _applyTurnEndAndAutoAdvance(current, action);
      case GameActionSurrender():
        return _applySurrender(current, action);
    }
  }

  GameState _applyGameStart(
    GameState current,
    GameActionGameStart action,
    GameSetupContext context,
  ) {
    return gameSetupService.execute(
      player: context.player,
      enemy: context.enemy,
      cardDefs: context.cardDefs,
      seed: context.seed,
    );
  }
}

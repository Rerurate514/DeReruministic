import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_start_draw_cards_service.g.dart';

@riverpod
GameStartDrawCardsService gameStartDrawCardsService(Ref ref) {
  return GameStartDrawCardsService(
    cardDrawService: ref.read(cardDrawServiceProvider),
  );
}

class GameStartDrawCardsService implements TurnProcessStep {
  const GameStartDrawCardsService({
    required this.cardDrawService,
  });

  final CardDrawService cardDrawService;

  @override
  ApplyActionResult execute(GameState state) {
    var currentState = state;
    final accumulatedSteps = <GameStepEvent>[];

    for (final playerId in currentState.players.keys) {
      final result = cardDrawService.execute(
        currentState,
        playerId,
        GameSystemConstants.initialGameStartDrawCardsCount,
      );

      currentState = result.state;
      accumulatedSteps.addAll(result.steps);
    }

    return ApplyActionResult(
      state: currentState,
      steps: accumulatedSteps,
    );
  }
}

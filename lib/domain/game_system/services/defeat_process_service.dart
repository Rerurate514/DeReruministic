import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline_middleware.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'defeat_process_service.g.dart';

@riverpod
DefeatProcessService defeatProcessService(Ref ref) {
  return const DefeatProcessService();
}

class DefeatProcessService implements TurnPipelineMiddleware {
  const DefeatProcessService();

  ApplyActionResult execute(
    GameState state, {
    required PlayerId loserPlayerId,
    required String reason,
  }) {
    final winnerPlayerId = state.players.keys.firstWhere(
      (id) => id != loserPlayerId,
    );

    final nextPhase = GamePhase(
      battlePhase: BattlePhase.battleEnd,
      turnOwner: state.phase.turnOwner,
    );

    final defeatStep = GameStepEvent.gameEnded(
      type: GameStepType.gameEnded,
      winnerPlayerId: winnerPlayerId,
      reason: reason,
    );

    final newState = state.copyWith(phase: nextPhase);

    return ApplyActionResult(
      state: newState,
      steps: [defeatStep],
    );
  }
}

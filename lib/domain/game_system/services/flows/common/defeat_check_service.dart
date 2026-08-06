import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_rule.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_end_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'defeat_check_service.g.dart';

@riverpod
DefeatCheckService defeatCheckService(Ref ref) {
  return DefeatCheckService(rules: [HpZeroDefeatRule(), DeckOutDefeatRule()]);
}

class DefeatCheckService implements TurnProcessStep {
  const DefeatCheckService({
    required this.rules,
  });

  final List<DefeatRule> rules;

  @override
  ApplyActionResult execute(GameState state) {
    final results = rules.expand((rule) => rule.evaluate(state)).toList();

    if (results.isEmpty) {
      return ApplyActionResult.noSteps(state: state);
    }

    final loserIds = results.map((r) => r.loserPlayerId).toSet().toList();

    final newState = state.copyWith(
      phase: state.phase.copyWith(battlePhase: .battleEnd),
    );

    final steps = _createEndSteps(state, results, loserIds);

    return ApplyActionResult(state: newState, steps: steps);
  }

  List<GameStepEvent> _createEndSteps(
    GameState state,
    List<DefeatResult> results,
    List<PlayerId> loserIds,
  ) {
    if (loserIds.length == 2) {
      return [
        const GameStepEvent.gameEnded(
          endResult: GameEndResult.draw,
          winnerPlayerId: null,
          loserPlayerId: null,
          reason: DefeatReason.simultaneousDefeat,
        ),
      ];
    }

    final loserId = loserIds.first;
    final winner = state.players.values.firstWhere(
      (player) => player.id != loserId,
    );
    final primaryResult = results.firstWhere(
      (result) => result.loserPlayerId == loserId,
    );

    return [
      GameStepEvent.gameEnded(
        endResult: GameEndResult.winnerDecided,
        winnerPlayerId: winner.id,
        loserPlayerId: loserId,
        reason: primaryResult.reason,
      ),
    ];
  }
}

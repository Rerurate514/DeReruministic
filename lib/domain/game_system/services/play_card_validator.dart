import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/validation_result.dart';

class PlayCardValidator {
  ValidationResult validate(GameState state, GameActionPlayCard action) {
    final cardUsedPlayer = state.players[action.playerId];

    if (cardUsedPlayer == null) {
      return const ValidationResultFailure(
        reason: ActionFailureReason.playerNotFound,
      );
    }

    if (state.phase.battlePhase != BattlePhase.mainPhase ||
        state.phase.turnOwner != action.playerId) {
      return const ValidationResultFailure(
        reason: ActionFailureReason.invalidPhase,
      );
    }

    final card = cardUsedPlayer.hand.firstWhereOrNull(
      (card) => card.instanceId == action.cardInstanceId,
    );

    if (card == null) {
      return const ValidationResultFailure(
        reason: ActionFailureReason.cardNotFound,
      );
    }

    if (cardUsedPlayer.currentCost < card.currentCost) {
      return const ValidationResultFailure(
        reason: ActionFailureReason.notEnoughCost,
      );
    }

    return const ValidationResultSuccess();
  }
}

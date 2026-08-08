import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/validation_result.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

class PlayCardValidator {
  ValidationResult validate({
    required GameState state,
    required PlayerId cardUsedPlayerId,
    required GameCardInstanceId usedCardInstanceId,
  }) {
    final cardUsedPlayer = state.players[cardUsedPlayerId];

    if (cardUsedPlayer == null) {
      return const ValidationResultFailure(
        reason: ActionFailureReason.playerNotFound,
      );
    }

    if (state.phase.battlePhase != BattlePhase.mainPhase ||
        state.phase.turnOwner != cardUsedPlayerId) {
      return const ValidationResultFailure(
        reason: ActionFailureReason.invalidPhase,
      );
    }

    final card = cardUsedPlayer.hand.firstWhereOrNull(
      (card) => card.instanceId == usedCardInstanceId,
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

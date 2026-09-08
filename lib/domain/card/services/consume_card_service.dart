import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/validation_result.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consume_card_service.g.dart';

@riverpod
ConsumeCardService consumeCardService(Ref ref) {
  return ConsumeCardService(playCardValidator: PlayCardValidator());
}

class ConsumeCardService {
  const ConsumeCardService({
    required this.playCardValidator,
  });

  final PlayCardValidator playCardValidator;

  ApplyActionResult execute({
    required GameState state,
    required PlayerId sourcePlayerId,
    required GameCardInstanceId instanceId,
  }) {
    final sourcePlayer = state.players[sourcePlayerId];

    if (sourcePlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final usedCard = sourcePlayer.hand.firstWhereOrNull(
      (card) => card.instanceId == instanceId,
    );
    if (usedCard == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.cardNotFound,
      );
    }

    final validateResult = playCardValidator.validate(
      state: state,
      cardUsedPlayerId: sourcePlayer.id,
      usedCardInstanceId: instanceId,
    );

    if (validateResult case ValidationResultFailure()) {
      return ApplyActionResult.failure(
        state: state,
        reason: validateResult.reason,
      );
    }

    const destinationZone = CardZone.playArea;

    final newState = state.moveCardFromHand(
      playerId: sourcePlayerId,
      cardInstanceId: instanceId,
      to: destinationZone,
    );

    final step = GameStepEvent.cardMovedZone(
      playerId: sourcePlayerId,
      cardInstanceIds: [instanceId],
      zoneFrom: CardZone.hand,
      zoneTo: destinationZone,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

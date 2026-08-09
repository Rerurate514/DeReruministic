import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
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
    required GameState current,
    required PlayerId sourcePlayerId,
    required GameCard card,
  }) {
    final sourcePlayer = current.players[sourcePlayerId];

    if (sourcePlayer == null) {
      return ApplyActionResult.failure(
        state: current,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final validateResult = playCardValidator.validate(
      state: current,
      cardUsedPlayerId: sourcePlayer.id,
      usedCardInstanceId: card.instanceId,
    );

    if (validateResult case ValidationResultFailure()) {
      return ApplyActionResult.failure(
        state: current,
        reason: validateResult.reason,
      );
    }

    final destinationZone = card.definition.isExhaustCard
        ? CardZone.exhausted
        : card.definition.isRecycleCard
        ? CardZone.deck
        : CardZone.graveyard;

    final newState = current.moveCardFromHand(
      playerId: sourcePlayerId,
      cardInstanceId: card.instanceId,
      to: destinationZone,
    );

    final step = GameStepEvent.cardMovedZone(
      playerId: sourcePlayerId,
      cardInstanceIds: [card.instanceId],
      zoneFrom: CardZone.hand,
      zoneTo: destinationZone,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

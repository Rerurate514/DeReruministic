import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
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
    required GameCard card,
  }) {
    final sourcePlayer = state.players[sourcePlayerId];

    if (sourcePlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final validateResult = playCardValidator.validate(
      state: state,
      cardUsedPlayerId: sourcePlayer.id,
      usedCardInstanceId: card.instanceId,
    );

    if (validateResult case ValidationResultFailure()) {
      return ApplyActionResult.failure(
        state: state,
        reason: validateResult.reason,
      );
    }

    final decrementedState = state.decrementRecycleCount(
      playerId: sourcePlayerId,
      cardInstanceId: card.instanceId,
    );

    final updatedCard = decrementedState.players[sourcePlayerId]?.hand
        .firstWhere((c) => c.instanceId == card.instanceId, orElse: () => card);

    final destinationZone =
        updatedCard?.definition.hasState<CardStateExhaust>() ?? false
        ? CardZone.exhausted
        : updatedCard?.isRecycleActive ?? false
        ? CardZone.deck
        : CardZone.graveyard;

    final newState = decrementedState.moveCardFromHand(
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

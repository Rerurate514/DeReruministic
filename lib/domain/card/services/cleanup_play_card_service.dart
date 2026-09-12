import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_states_trigger_type.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cleanup_play_card_service.g.dart';

@riverpod
CleanupPlayCardService cleanupPlayCardService(Ref ref) {
  return const CleanupPlayCardService();
}

class CleanupPlayCardService {
  const CleanupPlayCardService();

  ApplyActionResult execute({
    required GameState state,
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
  }) {
    final card = state.findGameCardInZone(
      playerId: playerId,
      instanceId: instanceId,
      zone: CardZone.playArea,
    );

    if (card == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.cardNotFound,
      );
    }

    if (card.definition.hasState<CardStateRecycle>()) {
      if (card.isRecycleActive) {
        return _enqueueMove(state, playerId, instanceId, CardZone.deck);
      } else {
        return _enqueueTrigger(
          state,
          playerId,
          instanceId,
          CardStatesTriggerType.recycleExpired,
        );
      }
    }

    if (card.definition.hasState<CardStateExhaust>()) {
      return _enqueueMove(state, playerId, instanceId, CardZone.exhausted);
    }

    return _enqueueMove(state, playerId, instanceId, CardZone.graveyard);
  }

  ApplyActionResult _enqueueMove(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
    CardZone zoneTo,
  ) {
    final newState = state.pushTask(
      GameStateTaskPushPos.head,
      .auto(
        .moveCardZone(
          playerId: playerId,
          instanceIds: [instanceId],
          zoneFrom: CardZone.playArea,
          zoneTo: zoneTo,
        ),
      ),
    );
    return ApplyActionResult.success(state: newState, steps: []);
  }

  ApplyActionResult _enqueueTrigger(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
    CardStatesTriggerType triggerType,
  ) {
    final newState = state.pushTask(
      GameStateTaskPushPos.head,
      .auto(
        .resolveCardStatesTrigger(
          playerId: playerId,
          instanceId: instanceId,
          triggerType: triggerType,
        ),
      ),
    );
    return ApplyActionResult.success(state: newState, steps: []);
  }
}

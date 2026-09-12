import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'move_card_zone_service.g.dart';

@riverpod
MoveCardZoneService moveCardZoneService(Ref ref) {
  return const MoveCardZoneService();
}

class MoveCardZoneService {
  const MoveCardZoneService();

  ApplyActionResult execute({
    required GameState state,
    required PlayerId playerId,
    required List<GameCardInstanceId> instanceIds,
    required CardZone zoneFrom,
    required CardZone zoneTo,
  }) {
    final player = state.players[playerId];
    if (player == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    if (zoneFrom == zoneTo) {
      return ApplyActionResult.noSteps(state: state);
    }

    var currentState = state;

    for (final instanceId in instanceIds) {
      final card = currentState.findGameCardInZone(
        playerId: playerId,
        instanceId: instanceId,
        zone: zoneFrom,
      );
      if (card == null) {
        return ApplyActionResult.failure(
          state: currentState,
          reason: ActionFailureReason.cardNotFound,
        );
      }

      currentState = currentState.moveCardZone(
        playerId: playerId,
        instanceId: instanceId,
        from: zoneFrom,
        to: zoneTo,
      );
    }

    final step = GameStepEvent.cardMovedZone(
      playerId: playerId,
      instanceIds: instanceIds,
      zoneFrom: zoneFrom,
      zoneTo: zoneTo,
    );

    return ApplyActionResult.success(
      state: currentState,
      steps: [step],
    );
  }
}

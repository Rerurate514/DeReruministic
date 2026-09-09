import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_states_trigger_type.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_triggered_card_states_service.g.dart';

@riverpod
ResolveTriggeredCardStatesService resolveTriggeredCardStatesService(Ref ref) {
  return ResolveTriggeredCardStatesService();
}

class ResolveTriggeredCardStatesService {
  ApplyActionResult execute({
    required GameState state,
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
    required CardStatesTriggerType triggerType,
  }) => switch (triggerType) {
    CardStatesTriggerType.recycleExpired => _applyRecycle(
      state,
      playerId,
      instanceId,
    ),
    // TODO: Handle this case.
    CardStatesTriggerType.decayExpired => throw UnimplementedError(),
    // TODO: Handle this case.
    CardStatesTriggerType.countdownExpired => throw UnimplementedError(),
  };

  ApplyActionResult _applyRecycle(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final newState = state.moveCardZone(
      playerId: playerId,
      instanceId: instanceId,
      from: CardZone.playArea,
      to: CardZone.exhausted,
    );

    final step = GameStepEvent.cardMovedZone(
      playerId: playerId,
      instanceIds: [instanceId],
      zoneFrom: CardZone.playArea,
      zoneTo: CardZone.exhausted,
    );
    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

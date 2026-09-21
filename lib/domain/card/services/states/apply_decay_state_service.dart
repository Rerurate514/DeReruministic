import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_decay_state_service.g.dart';

@riverpod
ApplyDecayStateService applyDecayStateService(Ref ref) {
  return ApplyDecayStateService();
}

class ApplyDecayStateService {
  ApplyActionResult execute(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final newState = state.moveCardZone(
      playerId: playerId,
      instanceId: instanceId,
      from: CardZone.hand,
      to: CardZone.exhausted,
    );

    final step = GameStepEvent.cardMovedZone(
      playerId: playerId,
      instanceIds: [instanceId],
      zoneFrom: CardZone.hand,
      zoneTo: CardZone.exhausted,
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [step],
    );
  }
}

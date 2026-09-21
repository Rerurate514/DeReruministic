import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_countdown_state_service.g.dart';

@riverpod
ApplyCountdownStateService applyCountdownStateService(Ref ref) {
  return ApplyCountdownStateService();
}

class ApplyCountdownStateService {
  ApplyActionResult execute(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    return ApplyActionResult.noSteps(state: state);
  }
}

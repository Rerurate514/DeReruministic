import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';

abstract class TurnProcessStep {
  ApplyActionResult execute(GameState state);
}

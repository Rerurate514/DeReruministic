import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_action_result.freezed.dart';
part 'apply_action_result.g.dart';

@freezed
sealed class ApplyActionResult with _$ApplyActionResult {
  const factory ApplyActionResult({
    required GameState state,
    required List<GameStepEvent> steps,
  }) = _ApplyActionResult;

  factory ApplyActionResult.noSteps({required GameState state}) =>
      ApplyActionResult(state: state, steps: []);

  factory ApplyActionResult.fromJson(Map<String, dynamic> json) =>
      _$ApplyActionResultFromJson(json);
}

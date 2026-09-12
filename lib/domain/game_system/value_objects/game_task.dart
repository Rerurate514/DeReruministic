import 'package:dereruministic/domain/game_system/value_objects/auto_game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/interactive_game_task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_task.freezed.dart';
part 'game_task.g.dart';

@freezed
sealed class GameTask with _$GameTask {
  const factory GameTask.auto(AutoGameTask task) = GameTaskAutoWrapper;
  const factory GameTask.interactive(InteractiveGameTask task) =
      GameTaskInteractiveWrapper;

  factory GameTask.fromJson(Map<String, dynamic> json) =>
      _$GameTaskFromJson(json);
}

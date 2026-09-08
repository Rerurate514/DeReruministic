import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interactive_game_task.freezed.dart';
part 'interactive_game_task.g.dart';

@freezed
sealed class InteractiveGameTask with _$InteractiveGameTask {
  // ユーザー入力待ちタスク
  const factory InteractiveGameTask.mainPhase({
    @PlayerIdConverter() required PlayerId activePlayerId,
  }) = InteractiveGameTaskMainPhase;

  const factory InteractiveGameTask.selectOverflowDiscard({
    @PlayerIdConverter() required PlayerId targetPlayerId,
    required int overflowCount,
  }) = InteractiveGameTaskSelectOverflowDiscard;

  factory InteractiveGameTask.fromJson(Map<String, dynamic> json) =>
      _$InteractiveGameTaskFromJson(json);
}

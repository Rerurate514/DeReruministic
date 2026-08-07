import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_targets.freezed.dart';
part 'action_targets.g.dart';

@freezed
sealed class ActionTargets with _$ActionTargets {
  const factory ActionTargets.player(PlayerId id) = ActionTargetPlayer;
  const factory ActionTargets.card(GameCardInstanceId id) = ActionTargetCard;
  const factory ActionTargets.slot(int index) = ActionTargetSlot;

  factory ActionTargets.fromJson(Map<String, dynamic> json) =>
      _$ActionTargetsFromJson(json);
}

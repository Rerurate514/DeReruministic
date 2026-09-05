import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:json_annotation/json_annotation.dart';

class GameActionsIdConverter implements JsonConverter<GameActionsId, String> {
  const GameActionsIdConverter();

  @override
  GameActionsId fromJson(String json) => GameActionsId(value: json);

  @override
  String toJson(GameActionsId object) => object.value;
}

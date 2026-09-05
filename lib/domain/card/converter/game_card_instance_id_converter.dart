import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class GameCardInstanceIdConverter
    implements JsonConverter<GameCardInstanceId, String> {
  const GameCardInstanceIdConverter();

  @override
  GameCardInstanceId fromJson(String json) => GameCardInstanceId(value: json);

  @override
  String toJson(GameCardInstanceId object) => object.value;
}

class GameCardInstanceIdListConverter
    implements JsonConverter<List<GameCardInstanceId>, List<dynamic>> {
  const GameCardInstanceIdListConverter();

  @override
  List<GameCardInstanceId> fromJson(List<dynamic> json) {
    return json.map((e) => GameCardInstanceId(value: e as String)).toList();
  }

  @override
  List<dynamic> toJson(List<GameCardInstanceId> object) {
    return object.map((e) => e.value).toList();
  }
}

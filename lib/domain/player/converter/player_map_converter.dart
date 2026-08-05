import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class PlayerMapConverter
    implements JsonConverter<Map<PlayerId, PlayerState>, Map<String, dynamic>> {
  const PlayerMapConverter();

  @override
  Map<PlayerId, PlayerState> fromJson(Map<String, dynamic> json) {
    return json.map(
      (key, value) => MapEntry(
        PlayerId(value: key),
        PlayerState.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson(Map<PlayerId, PlayerState> object) {
    return object.map(
      (key, value) => MapEntry(
        key.value,
        value.toJson(),
      ),
    );
  }
}

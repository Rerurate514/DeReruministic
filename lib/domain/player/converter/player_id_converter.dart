import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class PlayerIdConverter implements JsonConverter<PlayerId, String> {
  const PlayerIdConverter();

  @override
  PlayerId fromJson(String json) => PlayerId(value: json);

  @override
  String toJson(PlayerId object) => object.value;
}

class NullablePlayerIdConverter implements JsonConverter<PlayerId?, String?> {
  const NullablePlayerIdConverter();

  @override
  PlayerId? fromJson(String? json) =>
      json == null ? null : PlayerId(value: json);

  @override
  String? toJson(PlayerId? object) => object?.value;
}

import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class RoomIdConverter implements JsonConverter<RoomId, String> {
  const RoomIdConverter();

  @override
  RoomId fromJson(String json) => RoomId(value: json);

  @override
  String toJson(RoomId object) => object.value;
}

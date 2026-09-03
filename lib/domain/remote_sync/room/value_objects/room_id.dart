import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'room_id.freezed.dart';
part 'room_id.g.dart';

@freezed
abstract class RoomId with _$RoomId {
  const factory RoomId({required String value}) = _RoomId;

  factory RoomId.generate() {
    return RoomId(value: const Uuid().v4());
  }

  factory RoomId.fromJson(Map<String, dynamic> json) => _$RoomIdFromJson(json);
}

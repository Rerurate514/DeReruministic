import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_room_result.freezed.dart';
part 'join_room_result.g.dart';

@freezed
sealed class JoinRoomResult with _$JoinRoomResult {
  const factory JoinRoomResult.success({
    required Room room,
  }) = JoinRoomResultSuccess;

  const factory JoinRoomResult.roomNotFound() = JoinRoomResultRoomNotFound;

  const factory JoinRoomResult.roomAlreadyFull() =
      JoinRoomResultRoomAlreadyFull;

  const factory JoinRoomResult.roomAlreadyClosed() =
      JoinRoomResultRoomAlreadyClosed;

  factory JoinRoomResult.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomResultFromJson(json);
}

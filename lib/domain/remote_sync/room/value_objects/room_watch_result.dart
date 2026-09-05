import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_watch_result.freezed.dart';
part 'room_watch_result.g.dart';

@freezed
sealed class RoomWatchResult with _$RoomWatchResult {
  const RoomWatchResult._();

  const factory RoomWatchResult.available({
    required Room room,
  }) = RoomWatchResultAvailable;

  const factory RoomWatchResult.unavailable() = RoomWatchResultUnavailable;

  factory RoomWatchResult.fromJson(Map<String, dynamic> json) =>
      _$RoomWatchResultFromJson(json);
}

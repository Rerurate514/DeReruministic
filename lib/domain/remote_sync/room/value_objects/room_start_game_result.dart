import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_start_game_result.freezed.dart';
part 'room_start_game_result.g.dart';

@freezed
sealed class RoomStartGameResult with _$RoomStartGameResult {
  const factory RoomStartGameResult.success({
    required Room room,
  }) = RoomStartGameResultSuccess;

  const factory RoomStartGameResult.roomNotFound() =
      RoomStartGameResultRoomNotFound;

  const factory RoomStartGameResult.guestPlayerNotFound() =
      RoomStartGameResultGuestPlayerNotFound;

  factory RoomStartGameResult.fromJson(Map<String, dynamic> json) =>
      _$RoomStartGameResultFromJson(json);
}

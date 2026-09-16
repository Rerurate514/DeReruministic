import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/converter/room_id_converter.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_status.dart';
import 'package:dereruministic/infrastructure/remote_sync/room/converter/firebase_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_dto.freezed.dart';
part 'room_dto.g.dart';

@freezed
sealed class RoomDto with _$RoomDto {
  const factory RoomDto({
    @RoomIdConverter() required RoomId roomId,
    @PlayerIdConverter() required PlayerId hostPlayerId,
    required RoomStatus status,
    @FirestoreTimestampConverter() required Timestamp createdAt,
    @FirestoreTimestampConverter() required Timestamp updatedAt,
    @NullablePlayerIdConverter() PlayerId? guestPlayerId,
  }) = _RoomDto;

  factory RoomDto.fromJson(Map<String, dynamic> json) =>
      _$RoomDtoFromJson(json);
}

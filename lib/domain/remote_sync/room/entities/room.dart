import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/converter/firebase_timestamp_converter.dart';
import 'package:dereruministic/domain/remote_sync/converter/room_id_converter.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
sealed class Room with _$Room {
  const factory Room({
    @RoomIdConverter() required RoomId roomId,
    @PlayerIdConverter() required PlayerId hostPlayerId,
    required RoomStatus status,
    @FirestoreTimestampConverter() required Timestamp createdAt,
    @FirestoreTimestampConverter() required Timestamp updatedAt,
    @NullablePlayerIdConverter() PlayerId? guestPlayerId,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

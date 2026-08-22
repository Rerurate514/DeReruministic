import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/converter/firebase_timestamp_converter.dart';
import 'package:dereruministic/domain/remote_sync/value_objects/room_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
sealed class Room with _$Room {
  const factory Room({
    required PlayerId hostPlayerId,
    required PlayerId? guestPlayerId,
    required RoomStatus status,
    @FirestoreTimestampConverter() required Timestamp createdAt,
    @FirestoreTimestampConverter() required Timestamp updatedAt,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

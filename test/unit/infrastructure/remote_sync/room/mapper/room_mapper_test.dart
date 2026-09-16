import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_status.dart';
import 'package:dereruministic/infrastructure/remote_sync/room/mapper/room_mapper.dart';
import 'package:dereruministic/infrastructure/remote_sync/room/models/room_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomMapper', () {
    test('RoomDto の Timestamp と guestPlayerId を Room に変換する', () {
      final createdAt = DateTime.utc(2026);
      final updatedAt = DateTime.utc(2026, 1, 2);
      final guestPlayerId = PlayerId.generate();

      final room = RoomDto(
        roomId: RoomId.generate(),
        hostPlayerId: PlayerId.generate(),
        status: RoomStatus.ready,
        createdAt: Timestamp.fromDate(createdAt),
        updatedAt: Timestamp.fromDate(updatedAt),
        guestPlayerId: guestPlayerId,
      ).toEntity();

      expect(room.createdAt.toUtc(), createdAt);
      expect(room.updatedAt.toUtc(), updatedAt);
      expect(room.guestPlayerId, guestPlayerId);
    });
  });
}

import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:dereruministic/infrastructure/remote_sync/room/models/room_dto.dart';

extension RoomMapper on RoomDto {
  Room toEntity() {
    return Room(
      roomId: roomId,
      hostPlayerId: hostPlayerId,
      status: status,
      createdAt: createdAt.toDate(),
      updatedAt: updatedAt.toDate(),
      guestPlayerId: guestPlayerId,
    );
  }
}

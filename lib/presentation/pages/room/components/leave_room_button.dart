import 'dart:async';

import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/remote_sync/room/usecases/leave_room_usecase.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/presentation/components/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRoomButton extends ConsumerWidget {
  const LeaveRoomButton({
    required this.roomId,
    super.key,
  });

  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerId = ref.watch(currentUserProfileProvider.select((s) => s.id));
    return AppBackButton(
      onPressed: () async {
        unawaited(
          ref
              .read(leaveRoomUseCaseProvider)
              .execute(roomId: roomId, playerId: playerId),
        );
      },
    );
  }
}

import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/application/user/state/player_profile.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/presentation/pages/battle/components/battle_session.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BattlePage extends ConsumerWidget {
  const BattlePage({required this.roomId, super.key});
  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomData = ref.watch(roomWatchProvider(roomId: roomId));
    final player = ref.watch(currentUserProfileProvider).value;

    return roomData.when(
      data: (data) {
        if (player == null) return const UiLoadingIndicator();

        switch (data) {
          case RoomWatchResultAvailable(:final room):
            {
              final isHost = player.id == room.hostPlayerId;
              final enemyId = isHost ? room.guestPlayerId : room.hostPlayerId;
              if (enemyId == null) return const UiLoadingIndicator();

              final enemyData = ref.watch(playerProfileProvider(enemyId));

              return enemyData.when(
                data: (enemy) {
                  if (enemy == null) return const UiLoadingIndicator();

                  return BattleSession(
                    room: room,
                    player: player,
                    enemy: enemy,
                    isHost: isHost,
                  );
                },
                error: (error, stackTrace) => Text('$error, $stackTrace'),
                loading: UiLoadingIndicator.new,
              );
            }
          case RoomWatchResultUnavailable():
            {
              context.goNamed(
                RouterPaths.room.name,
                pathParameters: {'roomId': roomId.value},
              );

              return const SizedBox.shrink();
            }
        }
      },
      error: (error, stackTrace) => Text('$error, $stackTrace'),
      loading: UiLoadingIndicator.new,
    );
  }
}

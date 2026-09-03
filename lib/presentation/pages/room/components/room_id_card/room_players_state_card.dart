import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomPlayersStateCard extends ConsumerWidget {
  const RoomPlayersStateCard({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomWatchProvider(roomId: roomId));

    return AppCard(
      child: room.when(
        data: (data) {
          return switch (data) {
            RoomWatchResultAvailable(:final room) =>
              room.guestPlayerId != null
                  ? const Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text('Players Ready...'),
                        Text('[ 2 / 2 Player ]'),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text('Waiting Player...'),
                        Text('[ 1 / 2 Player ]'),
                      ],
                    ),
            RoomWatchResultUnavailable() => const Text('Error'),
          };
        },
        error: (error, stackTrace) => Text('$error, $stackTrace'),
        loading: () => const UiLoadingIndicator(),
      ),
    );
  }
}

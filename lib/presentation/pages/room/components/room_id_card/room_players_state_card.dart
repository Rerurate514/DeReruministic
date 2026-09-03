import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomPlayersStateCard extends ConsumerWidget {
  const RoomPlayersStateCard({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final room = ref.watch(roomWatchProvider(roomId: roomId));

    return AppCard(
      child: room.when(
        data: (data) {
          return switch (data) {
            RoomWatchResultAvailable(:final room) =>
              room.guestPlayerId != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.room_page_players_state_ready),
                        Text(l10n.room_page_players_state_ready_count),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.room_page_players_state_waiting),
                        Text(l10n.room_page_players_state_waiting_count),
                      ],
                    ),
            RoomWatchResultUnavailable() => Text(
              l10n.room_page_players_state_error,
            ),
          };
        },
        error: (error, stackTrace) => Text('$error, $stackTrace'),
        loading: () => const UiLoadingIndicator(),
      ),
    );
  }
}

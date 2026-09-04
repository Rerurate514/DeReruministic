import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_status.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/pages/room/components/game_start_button.dart';
import 'package:dereruministic/presentation/pages/room/components/leave_room_button.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/players_cards_section.dart';
import 'package:dereruministic/presentation/pages/room/components/room_id_card/room_id_card.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoomPage extends ConsumerWidget {
  const RoomPage({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(roomWatchProvider(roomId: roomId), (p, n) {
      n.whenData((data) {
        switch (data) {
          case RoomWatchResultAvailable(:final room):
            {
              if (room.status == RoomStatus.closed) {
                if (context.canPop()) context.pop();
              }
            }
          case RoomWatchResultUnavailable():
            {}
        }
      });
    });

    return UiPageWrapper(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              spacing: 16,
              children: [
                LeaveRoomButton(roomId: roomId),
                const Expanded(
                  child: FittedBox(
                    fit: .scaleDown,
                    child: AppTitle(),
                  ),
                ),
              ],
            ),
            const UiGap.s(),
            RoomIdCard(
              roomId: roomId,
            ),
            const UiGap.m(),
            PlayersCardsSection(
              roomId: roomId,
            ),
            const UiGap.m(),
            GameStartButton(
              roomId: roomId,
            ),
          ],
        ),
      ),
    );
  }
}

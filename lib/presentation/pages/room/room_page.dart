import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/pages/room/components/leave_room_button.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/players_cards_section.dart';
import 'package:dereruministic/presentation/pages/room/components/room_id_card/room_id_card.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context) {
    return UiPageWrapper(
      child: SingleChildScrollView(
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
            const PlayersCardsSection(),
            const UiGap.m(),
            const Text('ROOM IDはここ'),
          ],
        ),
      ),
    );
  }
}

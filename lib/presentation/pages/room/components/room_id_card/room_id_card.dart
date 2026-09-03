import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/pages/room/components/room_id_card/room_id_card_title.dart';
import 'package:dereruministic/presentation/pages/room/components/room_id_card/room_id_copy_button.dart';
import 'package:dereruministic/presentation/pages/room/components/room_id_card/room_id_text.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class RoomIdCard extends StatelessWidget {
  const RoomIdCard({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return AppHollowGlowCard(
      borderRadius: 0,
      color: theme.brandColor,
      backgroundColor: theme.surfaceContainer,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              const RoomIdCardTitle(),
              const Divider(),
              RoomIdText(
                roomId: roomId,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: RoomIdCopyButton(
              copiedText: roomId.value,
            ),
          ),
        ],
      ),
    );
  }
}

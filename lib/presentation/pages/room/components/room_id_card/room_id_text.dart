import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomIdText extends StatelessWidget {
  const RoomIdText({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return RichText(
      text: TextSpan(
        style: GoogleFonts.blackOpsOne(fontSize: 32),
        children: [
          TextSpan(
            text: '# ',
            style: TextStyle(
              color: theme.brandColor,
              shadows: [
                Shadow(
                  color: theme.brandColor.withAlpha(180),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          TextSpan(
            text: roomId.value,
            style: TextStyle(
              shadows: [
                Shadow(
                  color: theme.textSecondary.withAlpha(180),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

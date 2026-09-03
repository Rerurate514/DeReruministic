import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomIdText extends StatelessWidget {
  const RoomIdText({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          l10n.room_page_room_id_card_id_text,
          style: GoogleFonts.shareTechMono(
            color: theme.textPrimary.withAlpha(100),
          ),
        ),
        RichText(
          text: TextSpan(
            style: GoogleFonts.blackOpsOne(fontSize: 32),
            children: [
              TextSpan(
                text: l10n.room_page_room_id_card_id_prefix,
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
        ),
      ],
    );
  }
}

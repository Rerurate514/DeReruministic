import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_under_name_line.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardName extends StatelessWidget {
  const PlayerProfileCardName({
    required this.name,
    required this.isHost,
    this.isUnknown = false,
    super.key,
  });

  final String name;
  final bool isHost;
  final bool isUnknown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return PlayerProfileCardUnderNameLine(
      color: isUnknown ? theme.brandTertiary : null,
      child: Row(
        spacing: 8,
        children: [
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.shareTechMono(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (isHost) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.brandColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.room_page_player_profile_host,
                style: GoogleFonts.shareTechMono(
                  color: theme.brandColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

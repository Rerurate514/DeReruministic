import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardDeckReady extends StatelessWidget {
  const PlayerProfileCardDeckReady({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return Row(
      spacing: 4,
      children: [
        Icon(
          Icons.style,
          color: theme.brandSecondary,
          size: 14,
        ),
        Text(
          l10n.room_page_player_profile_deck_ready,
          style: GoogleFonts.shareTechMono(
            color: theme.brandSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

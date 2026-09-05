import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardDeckReady extends StatelessWidget {
  const PlayerProfileCardDeckReady({required this.isReady, super.key});

  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final color = isReady ? theme.brandSecondary : theme.brandTertiary;

    return Row(
      spacing: 4,
      children: [
        Icon(
          Icons.style,
          color: color,
          size: 14,
        ),
        Text(
          isReady
              ? l10n.room_page_player_profile_deck_ready
              : l10n.room_page_player_profile_deck_not_ready,
          style: GoogleFonts.shareTechMono(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

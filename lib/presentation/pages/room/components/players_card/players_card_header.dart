import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayersCardHeader extends StatelessWidget {
  const PlayersCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Symbols.stadia_controller, color: theme.brandSecondary),
            Text(
              l10n.room_page_players_card_header_title,
              style: GoogleFonts.shareTechMono(color: theme.textSecondary),
            ),
          ],
        ),
        Text(
          l10n.room_page_players_card_header_status,
          style: GoogleFonts.shareTechMono(color: theme.brandSecondary),
        ),
      ],
    );
  }
}

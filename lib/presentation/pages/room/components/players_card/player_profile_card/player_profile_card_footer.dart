import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardFooter extends StatelessWidget {
  const PlayerProfileCardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          children: [
            const UiActiveFilledCircle(),
            Text(
              l10n.room_page_player_profile_link_encrypted,
              style: GoogleFonts.shareTechMono(
                color: theme.textPrimary.withAlpha(100),
                fontSize: 11,
              ),
            ),
          ],
        ),
        Text(
          l10n.room_page_player_profile_deck_verified(40, 40),
          style: GoogleFonts.shareTechMono(
            color: theme.brandSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

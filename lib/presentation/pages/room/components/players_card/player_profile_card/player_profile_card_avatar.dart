import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardAvatar extends StatelessWidget {
  const PlayerProfileCardAvatar({required this.isYou, super.key});

  final bool isYou;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Stack(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.brandColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
            color: theme.brandColor.withOpacity(
              0.05,
            ),
          ),
          child: Icon(
            Icons.military_tech,
            color: theme.brandColor,
            size: 40,
          ),
        ),
        if (isYou)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: theme.brandColor,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                l10n.room_page_player_profile_you,
                style: GoogleFonts.shareTechMono(
                  color: theme.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

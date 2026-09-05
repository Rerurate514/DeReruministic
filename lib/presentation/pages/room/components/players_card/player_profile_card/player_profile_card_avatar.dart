import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class PlayerProfileCardAvatar extends StatelessWidget {
  const PlayerProfileCardAvatar({
    required this.isYou,
    super.key,
    this.isUnknown = false,
  });

  final bool isYou;
  final bool isUnknown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final color = isUnknown ? theme.brandTertiary : theme.brandColor;

    return Stack(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(
              0.05,
            ),
          ),
          child: Icon(
            isUnknown
                ? Symbols.android_wifi_3_bar_question
                : Icons.military_tech,
            color: color,
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

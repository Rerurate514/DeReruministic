import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardReadyChip extends StatelessWidget {
  const PlayerProfileCardReadyChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.brandQuaternary,
        ),
        borderRadius: BorderRadius.circular(6),
        color: theme.brandQuaternary.withOpacity(
          0.1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          UiActiveFilledCircle(
            color: theme.brandQuaternary,
          ),

          Text(
            l10n.room_page_player_profile_ready,
            style: GoogleFonts.shareTechMono(
              color: theme.brandQuaternary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

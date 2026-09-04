import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_filled_circle.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCardUnknownChip extends StatelessWidget {
  const PlayerProfileCardUnknownChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return UiFlashingWidget(
      color: theme.brandTertiary,
      tween: Tween<double>(begin: 0.5, end: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.brandTertiary,
          ),
          borderRadius: BorderRadius.circular(6),
          color: theme.brandTertiary.withOpacity(
            0.1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            UiFilledCircle(
              color: theme.brandTertiary,
            ),

            Text(
              l10n.room_page_player_profile_unknown,
              style: GoogleFonts.shareTechMono(
                color: theme.brandTertiary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

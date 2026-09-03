import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_square.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomIdCardTitleTrailing extends StatelessWidget {
  const RoomIdCardTitleTrailing({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return AppHollowGlowCard(
      color: theme.brandQuaternary,
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        spacing: 6,
        children: [
          UiActiveFilledSquare(
            color: theme.brandQuaternary,
          ),
          Text(
            l10n.room_page_room_id_card_title_trailing,
            style: GoogleFonts.shareTechMono(
              color: theme.brandQuaternary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class RoomIdCardTitle extends StatelessWidget {
  const RoomIdCardTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Row(
      spacing: 4,
      children: [
        Icon(Symbols.bug_report, color: theme.brandSecondary),
        Text(
          l10n.room_page_room_id_card_title,
          style: GoogleFonts.shareTechMono(color: theme.brandSecondary),
        ),
      ],
    );
  }
}

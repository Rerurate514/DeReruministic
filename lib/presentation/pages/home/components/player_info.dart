import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return AppCard(
      child: Row(
        spacing: 16,
        children: [
          Icon(
            Symbols.person,
            color: theme.brandSecondary,
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Player_01', //TODO(text): l10n
                style: GoogleFonts.shareTechMono(color: theme.brandSecondary),
              ),
              Text(
                'LVL 1 BEGINNER', //TODO(text): l10n
                style: GoogleFonts.shareTechMono(color: theme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

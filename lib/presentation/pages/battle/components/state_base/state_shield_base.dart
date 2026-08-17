import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class StateShieldBase extends StatelessWidget {
  const StateShieldBase({required this.shield, super.key});

  final int shield;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return FittedBox(
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        background: theme.surfaceContainer,
        child: Row(
          spacing: 4,
          children: [
            const Icon(
              Symbols.shield,
              size: 12,
            ),
            Text(
              shield.toString(),
              style: GoogleFonts.shareTechMono(
                fontWeight: .bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

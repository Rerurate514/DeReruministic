import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class StateCardCost extends StatelessWidget {
  const StateCardCost({required this.cost, super.key});

  final int cost;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return AppCard(
      background: theme.surfaceContainer.withAlpha(200),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(
            Symbols.bolt,
            size: 16,
            color: theme.brandSecondary,
          ),
          Text(
            cost.toString(),
            style: GoogleFonts.shareTechMono(
              fontSize: 16,
              color: theme.brandSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

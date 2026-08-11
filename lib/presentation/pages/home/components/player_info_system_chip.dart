import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerInfoSystemChip extends StatelessWidget {
  const PlayerInfoSystemChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return AppCard(
      child: Column(
        children: [
          Row(
            spacing: 16,
            children: [
              UiFlashingWidget(
                color: theme.brandSecondary,
                child: Icon(
                  Symbols.check_circle_filled,
                  color: theme.brandSecondary,
                  size: 16,
                ),
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'SYSTEM. OK', //TODO(text): l10n
                    style: GoogleFonts.shareTechMono(
                      color: theme.brandSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

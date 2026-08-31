import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/card_effects_details_ex.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefCardDetailArea extends StatelessWidget {
  const DefCardDetailArea({required this.defCard, super.key});

  final CardDefinition defCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Column(
        children: defCard.effects
            .map(
              (effect) => Text(
                effect.text(l10n),
                style: GoogleFonts.shareTechMono(
                  color: theme.brandSecondary,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

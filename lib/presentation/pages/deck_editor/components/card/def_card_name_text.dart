import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/presentation/painter/under_card_name_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefCardNameText extends StatelessWidget {
  const DefCardNameText({required this.defCard, super.key});

  final CardDefinition defCard;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Stack(
      children: [
        Text(
          defCard.name,
          style: GoogleFonts.shareTechMono(
            color: theme.brandColor,
            shadows: [
              Shadow(
                color: theme.brandColor,
                blurRadius: 1,
              ),
            ],
            letterSpacing: 1,
          ),
        ),
        CustomPaint(
          painter: UnderCardNamePainter(color: theme.brandSecondary),
        ),
      ],
    );
  }
}

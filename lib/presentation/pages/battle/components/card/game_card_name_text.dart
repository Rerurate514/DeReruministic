import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/painter/under_card_name_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameCardNameText extends StatelessWidget {
  const GameCardNameText({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Stack(
      children: [
        Text(
          gameCard.definition.name,
          style: GoogleFonts.shareTechMono(
            color: theme.brandSecondary,
            shadows: [
              Shadow(
                color: theme.brandSecondary,
                blurRadius: 0.7,
              ),
            ],
          ),
        ),
        CustomPaint(
          painter: UnderCardNamePainter(color: theme.brandSecondary),
        ),
      ],
    );
  }
}

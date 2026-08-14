import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameCardDetailArea extends StatelessWidget {
  const GameCardDetailArea({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Text(
        "ここに説明文",
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
    );
  }
}

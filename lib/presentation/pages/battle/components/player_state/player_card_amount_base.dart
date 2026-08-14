import 'package:dereruministic/presentation/painter/cards_amount_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerCardAmount extends StatelessWidget {
  const PlayerCardAmount({
    required this.icon,
    required this.label,
    required this.count,
    required this.iconColor,
    required this.painterColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color iconColor;
  final Color painterColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          spacing: 17,
          mainAxisSize: .min,
          children: [
            Icon(
              icon,
              size: 17,
              color: iconColor,
            ),
            Row(
              spacing: 2,
              mainAxisSize: .min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.shareTechMono(fontSize: 12),
                ),
                Text(
                  '$count',
                  style: GoogleFonts.shareTechMono(fontWeight: .bold),
                ),
              ],
            ),
          ],
        ),
        CustomPaint(
          painter: CardsAmountPainter(color: painterColor),
        ),
      ],
    );
  }
}

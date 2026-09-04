import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class PlayerProfileCardUnderNameLine extends StatelessWidget {
  const PlayerProfileCardUnderNameLine({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(100, 100);

    return Stack(
      children: [
        child,
        CustomPaint(
          painter: GlowLinePainter(path: path, color: theme.textSecondary),
        ),
      ],
    );
  }
}

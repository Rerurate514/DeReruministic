import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class PlayerProfileCardUnderNameLine extends StatelessWidget {
  const PlayerProfileCardUnderNameLine({
    required this.child,
    this.color,
    super.key,
  });

  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final path = Path()
      ..moveTo(-20, 35)
      ..lineTo(-10, 26)
      ..lineTo(100, 26);

    return Stack(
      children: [
        child,
        CustomPaint(
          painter: GlowLinePainter(
            path: path,
            color: color ?? theme.brandSecondary,
          ),
        ),
      ],
    );
  }
}

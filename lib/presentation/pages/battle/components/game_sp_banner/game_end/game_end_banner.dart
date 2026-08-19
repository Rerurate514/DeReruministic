import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/painter/corner_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class GameEndBanner extends StatelessWidget {
  const GameEndBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return SizedBox(
      height: 400,
      child: AppCard(
        isBlur: true,
        blurSigma: 10,
        padding: const EdgeInsets.all(32),
        child: CustomPaint(
          painter: CornerPainter(
            color: theme.brandSecondary,
            strokeWidth: 1.5,
            cornerLength: 40,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('GAME END (TEST)'),
            ],
          ),
        ),
      ),
    );
  }
}

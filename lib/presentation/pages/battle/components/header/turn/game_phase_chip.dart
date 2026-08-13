import 'dart:ui';

import 'package:dereruministic/presentation/pages/battle/components/header/turn/phase_text.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/turn/turn_text.dart';
import 'package:dereruministic/presentation/painter/hollow_glow_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class GamePhaseChip extends StatelessWidget {
  const GamePhaseChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return Stack(
      children: [
        Positioned.fill(
          child: _buildShadow(theme),
        ),
        _buildContent(theme),
      ],
    );
  }

  Widget _buildShadow(AppColorScheme theme) {
    return CustomPaint(
      size: const Size(200, 60),
      painter: HollowGlowPainter(
        color: theme.brandSecondary,
        blurRadius: 2,
        spreadWidth: 5,
        borderRadius: 1000,
      ),
    );
  }

  Widget _buildContent(AppColorScheme theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(color: theme.brandSecondary, width: 0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              spacing: 10,
              children: [
                const PhaseText(),
                Container(
                  width: 2,
                  height: 20,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(color: theme.surfaceContainer),
                ),
                const TurnText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

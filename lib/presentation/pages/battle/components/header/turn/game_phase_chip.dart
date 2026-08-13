import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/turn/phase_text.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/turn/turn_text.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class GamePhaseChip extends StatelessWidget {
  const GamePhaseChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return AppHollowGlowCard(
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
    );
  }
}

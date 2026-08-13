import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/state/card_state_list.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameCardSubs extends StatelessWidget {
  const GameCardSubs({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Column(
      children: [
        AppCard(
          background: theme.surfaceContainer.withAlpha(200),
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(
                Symbols.bolt,
                size: 16,
                color: theme.brandSecondary,
              ),
              Text(
                '${gameCard.currentCost}',
                style: GoogleFonts.shareTechMono(
                  fontSize: 16,
                  color: theme.brandSecondary,
                ),
              ),
            ],
          ),
        ),
        CardStateList(
          states: gameCard.definition.states,
          runtimeStates: gameCard.runtimeStates,
        ),
      ],
    );
  }
}

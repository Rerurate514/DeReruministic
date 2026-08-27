import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/state/card_state_list.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class DefCardMeta extends StatelessWidget {
  const DefCardMeta({required this.defCard, super.key});

  final CardDefinition defCard;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Column(
      crossAxisAlignment: .end,
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
                '${defCard.baseCost}',
                style: GoogleFonts.shareTechMono(
                  fontSize: 16,
                  color: theme.brandSecondary,
                ),
              ),
            ],
          ),
        ),
        CardStateList(
          states: defCard.states,
          runtimeStates: defCard.states.buildInitialRuntimeStates(),
        ),
      ],
    );
  }
}

import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/card_states_ex.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardStatesBase extends StatelessWidget {
  const CardStatesBase({required this.states, super.key});

  final CardStates states;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppCard(
      child: Row(
        spacing: 8,
        children: [
          AppCard(
            isBlur: true,
            blurSigma: 10,
            padding: const EdgeInsets.all(2),
            borderColor: states.color(theme),
            child: Icon(
              states.icon,
              color: states.color(theme),
              size: 20,
            ),
          ),
          Text(
            states.title(l10n),
            style: GoogleFonts.wdxlLubrifontJpN(),
          ),
          Expanded(
            child: Text(states.details(l10n)),
          ),
        ],
      ),
    );
  }
}

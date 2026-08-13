import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/card_runtime_states_ex.dart';
import 'package:dereruministic/presentation/utils/card_states_ex.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardStateComponent extends StatelessWidget {
  const CardStateComponent({
    required this.state,
    required this.runtimeStates,
    super.key,
  });

  final CardStates state;
  final CardRuntimeStates? runtimeStates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final color = state.color(theme);

    if (runtimeStates == null) return _buildIconCard(color);

    final right = switch (runtimeStates!) {
      CardRuntimeStateRecycleState() => -20,
      _ => -7,
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildIconCard(color),
        Positioned(
          right: right.toDouble(),
          bottom: -7,
          child: AppCard(
            isBlur: true,
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            borderColor: color.withOpacity(0.5),
            child: Text(
              runtimeStates!.text(l10n),
              style: GoogleFonts.shareTechMono(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: theme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconCard(Color color) {
    return AppCard(
      isBlur: true,
      blurSigma: 10,
      padding: const EdgeInsets.all(2),
      borderColor: color,
      child: Icon(
        state.icon,
        color: color,
        size: 20,
      ),
    );
  }
}

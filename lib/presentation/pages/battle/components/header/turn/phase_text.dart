import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_drum_roll_switcher.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/game_phase_ex.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhaseText extends HookConsumerWidget {
  const PhaseText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final displayedPhase =
        ref.watch(displayedPhaseProvider.select((s) => s?.battlePhase)) ??
        BattlePhase.initialize;

    return SizedBox(
      width: 110,
      child: AppDrumRollSwitcher(
        child: UiFlashingWidget(
          key: ValueKey(displayedPhase.name),
          tween: Tween<double>(begin: 1, end: 0.4),
          color: theme.brandSecondary,
          child: Text(
            displayedPhase.text(l10n),
            style: GoogleFonts.poppins(
              color: theme.brandSecondary,
              letterSpacing: 1.5,
              shadows: [Shadow(color: theme.brandSecondary, blurRadius: 0.7)],
            ),
          ),
        ),
      ),
    );
  }
}

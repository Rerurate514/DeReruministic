import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/game_phase_ex.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhaseText extends HookConsumerWidget {
  const PhaseText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final displayedPhase = useState<BattlePhase?>(.initialize);
    ref.listen(stepEventQueueProvider, (_, next) {
      if (next.isEmpty) return;

      final currentEvent = next.first;
      if (currentEvent is GameStepEventPhaseChanged) {
        displayedPhase.value = currentEvent.phase.battlePhase;
      }
    });

    return UiFlashingWidget(
      tween: Tween<double>(begin: 1, end: 0.4),
      color: theme.brandSecondary,
      child: Text(
        displayedPhase.value?.text(l10n) ?? l10n.game_state_is_null,
        style: GoogleFonts.poppins(
          color: theme.brandSecondary,
          letterSpacing: 1.5,
          shadows: [Shadow(color: theme.brandSecondary, blurRadius: 0.7)],
        ),
      ),
    );
  }
}

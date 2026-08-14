import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class EndTurnButton extends HookConsumerWidget {
  const EndTurnButton({required this.playerId, super.key});
  final PlayerId playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isLoading = useState(false);
    final canEndTurn = useState(false);
    final isMounted = useIsMounted();

    ref.listen(
      stepEventQueueProvider,
      (prev, next) {
        if (next.isEmpty) return;
        final phaseChangedEvent = next.firstOrNull;
        if (phaseChangedEvent == null) return;
        if (phaseChangedEvent is! GameStepEventPhaseChanged) return;
        canEndTurn.value =
            phaseChangedEvent.phase.battlePhase == .mainPhase &&
            phaseChangedEvent.phase.turnOwner == playerId;
      },
    );

    final isEnabled = canEndTurn.value && !isLoading.value;

    return SizedBox(
      width: 140,
      height: 40,
      child: AppHighlightTransparencyButton(
        isBlur: true,
        onPressed: isEnabled
            ? () async {
                isLoading.value = true;
                try {
                  await ref.read(gameProvider.notifier).endTurn();
                } finally {
                  if (isMounted()) {
                    isLoading.value = false;
                  }
                }
              }
            : null,
        child: Row(
          spacing: 4,
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            Text(
              l10n.battle_page_turn_end_button_text,
              style: GoogleFonts.shareTechMono(fontWeight: .bold),
            ),
            const Icon(Symbols.keyboard_double_arrow_right),
          ],
        ),
      ),
    );
  }
}

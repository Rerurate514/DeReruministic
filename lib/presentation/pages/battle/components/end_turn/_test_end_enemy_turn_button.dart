import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class TestEndEnemyTurnButton extends HookConsumerWidget {
  const TestEndEnemyTurnButton({required this.playerId, super.key});
  final PlayerId playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    final currentPhase = ref.watch(displayedPhaseProvider);
    final canEndTurn =
        currentPhase?.battlePhase == .mainPhase &&
        currentPhase?.turnOwner != playerId;

    final isEnabled = canEndTurn && !isLoading.value;

    return SizedBox(
      width: 240,
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
              'TEST: ENEMY TURN END',
              style: GoogleFonts.shareTechMono(fontWeight: .bold),
            ),
            const Icon(Symbols.keyboard_double_arrow_right),
          ],
        ),
      ),
    );
  }
}

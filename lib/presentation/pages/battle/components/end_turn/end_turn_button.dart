import 'package:dereruministic/application/game/state/game_notifier.dart';
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
    final turnOwner = ref.watch(gameProvider.select((s) => s?.phase.turnOwner));

    final isEnable = turnOwner == playerId && !isLoading.value;

    return SizedBox(
      width: 140,
      height: 40,
      child: AppHighlightTransparencyButton(
        isBlur: true,
        onPressed: isEnable
            ? () async {
                isLoading.value = true;
                try {
                  await ref.read(gameProvider.notifier).endTurn();
                } finally {
                  isLoading.value = false;
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

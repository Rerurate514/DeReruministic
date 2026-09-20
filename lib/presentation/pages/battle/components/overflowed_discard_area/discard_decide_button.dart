import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_overflow_check_triggered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscardDecideButton extends ConsumerWidget {
  const DiscardDecideButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final overflowCount = ref.watch(displayedOverflowCheckTriggeredProvider);
    final selectOverflowDiscards = ref.watch(selectDiscardCardsProvider);

    if (overflowCount == null) return const SizedBox.shrink();
    return AppHighlightTransparencyButton(
      width: 150,
      onPressed: () async {
        ref.read(displayedOverflowCheckTriggeredProvider.notifier).clear();
        ref.read(selectDiscardCardsProvider.notifier).clear();
        ref.read(animationSignalProvider.notifier).done();
        await ref
            .read(gameProvider.notifier)
            .selectOverflowDiscards(
              selectOverflowDiscards.map((card) => card.instanceId).toList(),
            );
      },
      child: Text(l10n.battle_page_discard_decide_button_text),
    );
  }
}

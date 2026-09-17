import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_overflow_check_triggered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OverflowCountText extends ConsumerWidget {
  const OverflowCountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final overflowTriggered = ref.watch(
      displayedOverflowCheckTriggeredProvider,
    );
    final currentSelectedCount = ref.watch(
      selectDiscardCardsProvider.select((s) => s.length),
    );

    if (overflowTriggered == null ||
        overflowTriggered is! GameStepEventOverflowCheckTriggered) {
      return const SizedBox.shrink();
    }

    return Text(
      l10n.battle_page_overflow_count(
        currentSelectedCount,
        overflowTriggered.overflowCount,
      ),
      style: GoogleFonts.shareTechMono(),
    );
  }
}

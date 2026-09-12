import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_overflow_check_triggered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverflowCountText extends ConsumerWidget {
  const OverflowCountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overflowCount = ref.watch(displayedOverflowCheckTriggeredProvider);
    final currentSelectedCount = ref.watch(
      selectDiscardCardsProvider.select((s) => s.length),
    );

    if (overflowCount == null) return const SizedBox.shrink();

    return Text('残り: $currentSelectedCount / $overflowCount');
  }
}

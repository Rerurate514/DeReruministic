import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_overflow_check_triggered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverflowedDiscardArea extends ConsumerWidget {
  const OverflowedDiscardArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overflowCount = ref.watch(displayedOverflowCheckTriggeredProvider);
    if (overflowCount == null) return const SizedBox.shrink();

    return Text('$overflowCount');
  }
}

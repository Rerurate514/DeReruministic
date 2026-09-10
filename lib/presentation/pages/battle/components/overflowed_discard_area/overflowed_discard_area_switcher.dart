import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflowed_discard_area_container.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_overflow_check_triggered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverflowedDiscardAreaSwitcher extends ConsumerWidget {
  const OverflowedDiscardAreaSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overflowCount = ref.watch(displayedOverflowCheckTriggeredProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: overflowCount != null
          ? const OverflowedDiscardAreaContainer()
          : const SizedBox.shrink(),
    );
  }
}

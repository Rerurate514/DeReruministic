import 'package:dereruministic/presentation/pages/battle/components/event_log/event_log_component.dart';
import 'package:dereruministic/presentation/pages/battle/providers/switcher/event_log_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventLogSwitcher extends ConsumerWidget {
  const EventLogSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShow = ref.watch(eventLogSwitcherProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            );

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: isShow ? EventLogComponent() : const SizedBox.shrink(),
    );
  }
}

import 'package:dereruministic/presentation/pages/battle/components/guide/tactical_guide.dart';
import 'package:dereruministic/presentation/pages/battle/providers/switcher/guide_switcher.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TacticalGuideSwitcher extends ConsumerWidget {
  const TacticalGuideSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShow = ref.watch(guideSwitcherProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: isShow ? const TacticalGuide() : const SizedBox.shrink(),
    );
  }
}

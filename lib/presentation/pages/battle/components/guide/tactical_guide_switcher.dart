import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/tactical_guide.dart';
import 'package:dereruministic/presentation/pages/battle/providers/switcher/guide_switcher.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TacticalGuideSwitcher extends ConsumerWidget {
  const TacticalGuideSwitcher({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShow = ref.watch(guideSwitcherProvider);
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
      child: isShow
          ? TacticalGuide(
              player: player,
            )
          : const SizedBox.shrink(),
    );
  }
}

import 'dart:async';

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/phase/phase_banner.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhaseBannerAnimationContainer extends HookConsumerWidget {
  const PhaseBannerAnimationContainer({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayedPhase = ref.watch(displayedPhaseProvider);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );

    final curvedAnimation = useMemoized(
      () => CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuad,
        reverseCurve: Curves.easeInQuad,
      ),
      [controller],
    );

    useEffect(() {
      if (displayedPhase == null) return null;

      Future<void> runProcessedAnimation() async {
        await controller.forward(
          from: 0,
        );

        await Future<void>.delayed(const Duration(milliseconds: 900));

        await controller
            .reverse(
              from: 1,
            )
            .whenComplete(
              () => ref.read(animationSignalProvider.notifier).done(),
            );
      }

      unawaited(runProcessedAnimation());

      return null;
    }, [displayedPhase]);

    if (displayedPhase == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: curvedAnimation,
      child: PhaseBanner(
        phase: displayedPhase,
        player: player,
      ),
      builder: (context, child) {
        final dx = 1 - (curvedAnimation.value) + 0.1;
        return FractionalTranslation(
          translation: Offset(dx, 0),
          child: child,
        );
      },
    );
  }
}

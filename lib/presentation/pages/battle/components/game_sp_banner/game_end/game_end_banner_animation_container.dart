import 'dart:async';

import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/game_start_banner.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_game_start_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameEndBannerAnimationContainer extends HookConsumerWidget {
  const GameEndBannerAnimationContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    final isShow = ref.watch(displayedGameStartProvider);

    final animation = useMemoized(
      () => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeOutQuad)),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: ConstantTween<double>(1),
          weight: 60,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 2,
          ).chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 20,
        ),
      ]).animate(controller),
      [controller],
    );

    final isMounted = useIsMounted();
    useEffect(() {
      if (!isShow) return;
      Future<void> runAnimationSequence() async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await controller
            .forward(from: 0)
            .whenComplete(
              () => ref.read(animationSignalProvider.notifier).done(),
            );
        if (!isMounted()) return;
        ref.read(displayedGameStartProvider.notifier).setFalse();
      }

      unawaited(runAnimationSequence());

      return null;
    }, [isShow]);

    if (!isShow) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: animation,
      child: const GameStartBanner(),
      builder: (context, child) {
        final dx = 1 - (animation.value);
        return FractionalTranslation(
          translation: Offset(dx, 0),
          child: child,
        );
      },
    );
  }
}

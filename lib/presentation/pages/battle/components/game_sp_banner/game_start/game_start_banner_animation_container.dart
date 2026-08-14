import 'dart:async';

import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/game_start_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameStartBannerAnimationContainer extends HookConsumerWidget {
  const GameStartBannerAnimationContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    final isShow = useState(false);

    ref.listen(stepEventQueueProvider, (_, next) {
      if (next.isEmpty) return;

      final currentEvent = next.first;
      if (currentEvent is GameStepEventGameStarted) {
        isShow.value = true;
      }
    });

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

    useEffect(() {
      if (!isShow.value) return;

      Future<void> runAnimationSequence() async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await controller.forward(from: 0);
        ref.read(stepEventQueueProvider.notifier).consumeCurrentStep();
        isShow.value = false;
      }

      unawaited(runAnimationSequence());

      return null;
    }, [isShow.value]);

    if (!isShow.value) return const SizedBox.shrink();

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

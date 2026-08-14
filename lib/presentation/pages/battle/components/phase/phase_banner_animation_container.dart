import 'dart:async';

import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/presentation/pages/battle/components/phase/phase_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhaseBannerAnimationContainer extends HookConsumerWidget {
  const PhaseBannerAnimationContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestPhase = ref.watch(gameProvider.select((s) => s?.phase));
    final displayedPhase = useState<GamePhase?>(latestPhase);
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

    ref.listen(stepEventQueueProvider, (_, next) {
      if (next.isEmpty) return;

      final currentEvent = next.first;
      if (currentEvent is GameStepEventPhaseChanged) {
        displayedPhase.value = currentEvent.phase;
      }
    });

    useEffect(() {
      if (displayedPhase.value != null) {}

      Future<void> runProcessedAnimation() async {
        await controller.forward(
          from: 0,
        );

        await Future<void>.delayed(const Duration(milliseconds: 900));

        await controller.reverse(
          from: 1,
        );
      }

      unawaited(runProcessedAnimation());

      return null;
    }, [displayedPhase.value]);

    if (displayedPhase.value == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: curvedAnimation,
      child: PhaseBanner(
        phase: displayedPhase.value!,
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

import 'dart:async';

import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_component.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_card_played_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardPlayedAnimationContainer extends HookConsumerWidget {
  const CardPlayedAnimationContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    final step = ref.watch(displayedCardPlayedProvider);
    if (step is! GameStepEventCardPlayed) return const SizedBox.shrink();
    final player = ref.watch(currentUserProfileProvider.select((s) => s.value));
    if (player == null) return const SizedBox.shrink();
    final isMe = step.playerId == player.id;

    final begin = isMe ? 0.0 : 2.0;
    final end = isMe ? 2.0 : 0.0;

    final animation = useMemoized(
      () => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: begin,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeOutQuad)),
          weight: 20,
        ),
        TweenSequenceItem(tween: ConstantTween<double>(1), weight: 60),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 20,
        ),
      ]).animate(controller),
      [controller],
    );

    useEffect(() {
      Future<void> runAnimation() async {
        try {
          await controller.forward(from: 0);
        } finally {
          ref.read(displayedCardPlayedProvider.notifier).clear();
        }
      }

      unawaited(runAnimation());

      return null;
    }, [step]);

    final gameState = ref.read(gameProvider);
    if (gameState == null) return const SizedBox.shrink();

    final gameCard = gameState.findPlayedCardInAllZone(
      playerId: step.playerId,
      instanceId: step.instanceId,
    );
    if (gameCard == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: animation,
      child: GameCardComponent(
        gameCard: gameCard,
      ),
      builder: (context, child) {
        final dy = 1 - animation.value;
        return FractionalTranslation(
          translation: Offset(0, dy),
          child: child,
        );
      },
    );
  }
}

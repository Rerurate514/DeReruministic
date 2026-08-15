import 'dart:async';

import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/hand/hand_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_card_drawn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HandComponent extends StatefulHookConsumerWidget {
  const HandComponent({required this.player, super.key});
  final Player player;

  @override
  ConsumerState<HandComponent> createState() => _HandComponentState();
}

class _HandComponentState extends ConsumerState<HandComponent>
    with TickerProviderStateMixin {
  final Map<GameCardInstanceId, AnimationController> _controllers = {};

  AnimationController _controllerFor(GameCardInstanceId instanceId) {
    return _controllers.putIfAbsent(
      instanceId,
      () => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );
  }

  void _disposeUnused(Iterable<GameCardInstanceId> currentIds) {
    final removed = _controllers.keys
        .where((id) => !currentIds.contains(id))
        .toList();
    for (final id in removed) {
      _controllers.remove(id)?.dispose();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hand = ref.watch(
      myPlayerUiStateProvider(widget.player).select((s) => s?.hand),
    );

    final cardDrawnEvent = ref.watch(
      displayedCardDrawnEventForPlayerProvider(widget.player.id),
    );

    if (hand == null) return const SizedBox.shrink();

    _disposeUnused(hand.map((c) => c.instanceId));

    useEffect(() {
      if (cardDrawnEvent == null) return null;
      Future<void> run() async {
        await Future.wait(
          hand.map((card) async {
            await Future<void>.delayed(
              Duration(milliseconds: 100 * hand.indexOf(card)),
            );
            _controllerFor(card.instanceId).forward(from: 0);
          }),
        );

        ref.read(stepEventQueueProvider.notifier).consumeCurrentStep();
        ref.read(stepEventQueueProvider.notifier).consumeCurrentStep();
      }

      unawaited(run());
      return null;
    }, [cardDrawnEvent]);

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hand.length,
        itemBuilder: (context, index) {
          final card = hand[index];
          return HandAnimationContainer(
            key: ValueKey(card.instanceId),
            gameCard: card,
            controller: _controllerFor(card.instanceId),
          );
        },
      ),
    );
  }
}

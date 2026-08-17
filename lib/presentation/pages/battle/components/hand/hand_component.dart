import 'dart:async';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/hand/hand_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_card_drawn_animation_notifier.dart';
import 'package:dereruministic/presentation/widgets/ui_size_fade_no_clip.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HandComponent extends StatefulHookConsumerWidget {
  const HandComponent({required this.player, super.key});
  final Player player;

  @override
  ConsumerState<HandComponent> createState() => _HandComponentState();
}

class _HandComponentState extends ConsumerState<HandComponent>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  static const _cardDuration = Duration(milliseconds: 400);
  static const _stagger = Duration(milliseconds: 100);

  final Set<GameCardInstanceId> _revealed = {};
  List<GameCardInstanceId> _targets = const [];

  Future<void> _play(List<GameCardInstanceId> handIds) async {
    final targets = handIds.where((id) => !_revealed.contains(id)).toList();
    if (targets.isEmpty) {
      ref.read(animationSignalProvider.notifier).done();
      return;
    }
    try {
      if (targets.isEmpty) return;
      setState(() => _targets = targets);
      _controller.duration = _cardDuration + _stagger * (targets.length - 1);
      await _controller.forward(from: 0);
    } finally {
      if (mounted) {
        setState(() {
          _revealed.addAll(targets);
          _targets = const [];
        });
        ref.read(animationSignalProvider.notifier).done();
      }
    }
  }

  Animation<double> _animationFor(GameCardInstanceId id) {
    if (_revealed.contains(id)) return const AlwaysStoppedAnimation(1);

    final i = _targets.indexOf(id);
    if (i < 0) return const AlwaysStoppedAnimation(0);
    final total = _controller.duration!.inMilliseconds;
    final begin = _stagger.inMilliseconds * i / total;
    final end = (begin + _cardDuration.inMilliseconds / total).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hand = ref.watch(
      myPlayerUiStateProvider(widget.player).select((s) => s?.hand),
    );

    if (hand == null) return const SizedBox.shrink();

    _revealed.retainAll(hand.map((c) => c.instanceId).toSet());

    ref.listen(displayedCardDrawnAnimationProvider, (_, req) {
      if (req == null) return;
      unawaited(_play(req.targets));
    });

    return SizedBox(
      height: 240,
      child: ImplicitlyAnimatedList<GameCard>(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        items: hand,
        areItemsTheSame: (oldItem, newItem) =>
            oldItem.instanceId == newItem.instanceId,
        itemBuilder: (context, animation, card, index) {
          return UiSizeFadeNoClip(
            animation: animation,
            child: HandAnimationContainer(
              key: ValueKey(card.instanceId),
              gameCard: card,
              animation: _animationFor(card.instanceId),
            ),
          );
        },
        removeItemBuilder: (context, animation, card) {
          return UiSizeFadeNoClip(
            animation: animation,
            child: HandAnimationContainer(
              key: ValueKey(card.instanceId),
              gameCard: card,
              animation: const AlwaysStoppedAnimation(0),
            ),
          );
        },
      ),
    );
  }
}

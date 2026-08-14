import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_draggable.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HandComponent extends ConsumerWidget {
  const HandComponent({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hand = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.hand),
    );

    if (hand == null) return const SizedBox.shrink();

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hand.length,
        itemBuilder: (context, index) {
          return GameCardDraggable(
            key: ValueKey(hand[index].instanceId),
            gameCard: hand[index],
          );
        },
      ),
    );
  }
}

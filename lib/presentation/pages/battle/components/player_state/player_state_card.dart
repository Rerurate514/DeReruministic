import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state_name.dart';
import 'package:flutter/widgets.dart';

class PlayerStateCard extends StatelessWidget {
  const PlayerStateCard({required this.player, super.key});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppCard(
        borderRadius: 4,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            PlayerStateName(
              player: player,
            ),
          ],
        ),
      ),
    );
  }
}

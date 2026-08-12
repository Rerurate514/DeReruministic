import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state_card.dart';
import 'package:flutter/widgets.dart';

class PlayerState extends StatelessWidget {
  const PlayerState({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return PlayerStateCard(
      player: player,
    );
  }
}

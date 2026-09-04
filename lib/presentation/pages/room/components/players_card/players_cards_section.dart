import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/players_card_header.dart';
import 'package:flutter/material.dart';

class PlayersCardsSection extends StatelessWidget {
  const PlayersCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 8,
      children: [
        PlayersCardHeader(),
        PlayerProfileCard(
          name: 'Player_01',
          level: 32,
          isHost: true,
          isYou: true,
        ),
        PlayerProfileCard(
          name: 'Player_02',
          level: 64,
          isHost: false,
          isYou: false,
        ),
      ],
    );
  }
}

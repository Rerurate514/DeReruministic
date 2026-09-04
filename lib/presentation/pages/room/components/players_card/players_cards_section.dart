import 'package:dereruministic/presentation/pages/room/components/players_card/players_card_header.dart';
import 'package:flutter/material.dart';

class PlayersCardsSection extends StatelessWidget {
  const PlayersCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [PlayersCardHeader()],
    );
  }
}

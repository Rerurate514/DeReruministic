import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_deck_card_amount.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_exhausted_card_amout.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_graveyard_card_amout.dart';
import 'package:flutter/material.dart';

class PlayerCardsAmounts extends StatelessWidget {
  const PlayerCardsAmounts({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceAround,
      children: [
        PlayerDeckCardAmount(
          player: player,
        ),
        PlayerGraveyardCardAmount(
          player: player,
        ),
        PlayerExhaustedCardAmount(
          player: player,
        ),
      ],
    );
  }
}

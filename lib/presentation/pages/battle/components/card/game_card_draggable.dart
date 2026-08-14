import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_component.dart';
import 'package:flutter/material.dart';

class GameCardDraggable extends StatelessWidget {
  const GameCardDraggable({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context) {
    return Draggable<GameCard>(
      data: gameCard,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: GameCardComponent(
            gameCard: gameCard,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: GameCardComponent(
          gameCard: gameCard,
        ),
      ),
      child: GameCardComponent(
        gameCard: gameCard,
      ),
    );
  }
}

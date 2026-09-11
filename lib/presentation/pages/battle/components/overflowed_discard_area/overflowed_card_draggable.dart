import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_component.dart';
import 'package:dereruministic/presentation/pages/battle/state/in_card_discard_area.dart';
import 'package:flutter/material.dart';

class OverflowedCardDraggable extends StatelessWidget {
  const OverflowedCardDraggable({
    required this.gameCard,
    required this.createGameCard,
    this.onDragStarted,
    this.onDragEnd,
    super.key,
  });

  final GameCard gameCard;
  final InCardDiscardArea Function(GameCard gameCard) createGameCard;
  final void Function()? onDragStarted;
  final void Function(DraggableDetails)? onDragEnd;

  @override
  Widget build(BuildContext context) {
    return Draggable<InCardDiscardArea>(
      data: createGameCard(gameCard),
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
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

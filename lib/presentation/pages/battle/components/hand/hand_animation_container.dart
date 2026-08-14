import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_draggable.dart';
import 'package:flutter/material.dart';

class HandAnimationContainer extends StatelessWidget {
  const HandAnimationContainer({
    required this.gameCard,
    required this.controller,
    super.key,
  });

  final GameCard gameCard;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutQuad,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: GameCardDraggable(gameCard: gameCard),
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(0, animation.value),
          child: child,
        );
      },
    );
  }
}

import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflow_hand_card_wrapper.dart';
import 'package:flutter/material.dart';

class HandAnimationContainer extends StatelessWidget {
  const HandAnimationContainer({
    required this.gameCard,
    required this.animation,
    super.key,
  });

  final GameCard gameCard;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: OverflowHandCardWrapper(gameCard: gameCard),
      builder: (context, child) {
        final dx = animation.value.clamp(0.0, 1.0);
        return FractionalTranslation(
          translation: Offset(0, 1 - dx),
          child: child,
        );
      },
    );
  }
}

import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_detail_area.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class GameCardBaseWidget extends StatelessWidget {
  const GameCardBaseWidget({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return AppCard(
      borderWidth: 0,
      padding: EdgeInsets.zero,
      background: theme.surfaceContainer.withAlpha(200),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Image.network(
              'https://t4.ftcdn.net/jpg/06/50/75/75/360_F_650757554_7uqwFCbihGakJVbaCyYmD4hPtIrBWAqu.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const Divider(
            height: 0,
          ),
          Expanded(
            flex: 6,
            child: GameCardDetailArea(gameCard: gameCard),
          ),
        ],
      ),
    );
  }
}

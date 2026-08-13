import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/components/app_glow_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_detail_area.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_subs.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_interlacing_artifacts_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameCardComponent extends ConsumerWidget {
  const GameCardComponent({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    return SizedBox(
      width: 180,
      height: 240,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppGlowContainer(
              child: AppCard(
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
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GameCardSubs(
              gameCard: gameCard,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ScanlinePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

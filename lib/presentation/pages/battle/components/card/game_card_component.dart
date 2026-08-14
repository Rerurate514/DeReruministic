import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/presentation/components/app_glow_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_base_component.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_meta.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_name_text.dart';
import 'package:dereruministic/presentation/painter/under_card_painter.dart';
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
              child: Stack(
                children: [
                  GameCardBaseComponent(
                    gameCard: gameCard,
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ScanlinePainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GameCardMeta(
              gameCard: gameCard,
            ),
          ),
          Positioned(
            child: GameCardNameText(
              gameCard: gameCard,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomPaint(
              painter: UnderCardPainter(color: theme.brandSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

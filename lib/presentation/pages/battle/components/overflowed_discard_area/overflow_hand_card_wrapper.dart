import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_draggable.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OverflowHandCardWrapper extends ConsumerWidget {
  const OverflowHandCardWrapper({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final isDraggable = !ref
        .watch(selectDiscardCardsProvider)
        .map((card) => card.instanceId)
        .contains(gameCard.instanceId);

    const x = 180.0;
    const y = 240.0;

    final path = Path()
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..lineTo(0, 0)
      ..lineTo(x, y)
      ..moveTo(0, y)
      ..lineTo(x, 0);

    return Stack(
      children: [
        GameCardDraggable(
          gameCard: gameCard,
          isDraggable: isDraggable,
        ),
        if (isDraggable)
          const SizedBox.shrink()
        else
          Positioned.fill(
            child: Stack(
              children: [
                _DiscardedPaint(
                  x: x,
                  y: y,
                  path: path,
                  theme: theme,
                ),
                Align(
                  child: _CenterContent(
                    l10n: l10n,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CenterContent extends StatelessWidget {
  const _CenterContent({
    required this.l10n,
    required this.theme,
  });

  final AppLocalizations l10n;
  final AppColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      isBlur: true,
      child: Text(
        l10n.battle_page_in_discarded_card_text,
        style: GoogleFonts.shareTechMono(
          color: theme.brandTertiary,
        ),
      ),
    );
  }
}

class _DiscardedPaint extends StatelessWidget {
  const _DiscardedPaint({
    required this.x,
    required this.y,
    required this.path,
    required this.theme,
  });

  final double x;
  final double y;
  final Path path;
  final AppColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(2),
      isBlur: true,
      child: FittedBox(
        child: CustomPaint(
          size: Size(x, y),
          painter: GlowLinePainter(
            path: path,
            color: theme.brandTertiary,
          ),
        ),
      ),
    );
  }
}

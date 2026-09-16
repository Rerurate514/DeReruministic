import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card_cross_paint.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_draggable.dart';
import 'package:dereruministic/presentation/pages/battle/providers/select_discard_cards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverflowHandCardWrapper extends ConsumerWidget {
  const OverflowHandCardWrapper({required this.gameCard, super.key});

  final GameCard gameCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final isDraggable = !ref
        .watch(selectDiscardCardsProvider)
        .map((card) => card.instanceId)
        .contains(gameCard.instanceId);

    return AppCardCrossPaint(
      label: l10n.battle_page_in_discarded_card_text,
      isVisible: !isDraggable,
      child: GameCardDraggable(
        gameCard: gameCard,
        isDraggable: isDraggable,
      ),
    );
  }
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_card_amount_base.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class PlayerDeckCardAmount extends ConsumerWidget {
  const PlayerDeckCardAmount({required this.player, super.key});
  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final deckCount = ref
        .watch(
          myPlayerUiStateProvider(player).select((s) => s?.deck),
        )
        ?.length;

    return PlayerCardAmount(
      icon: Symbols.playing_cards,
      label: l10n.battle_page_player_deck_count_text,
      count: deckCount ?? 0,
      iconColor: theme.zoneDeck,
      painterColor: theme.brandSecondary,
    );
  }
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return Column(
      spacing: 2,
      children: [
        Icon(
          Symbols.playing_cards,
          size: 22,
          color: theme.zoneDeck,
        ),
        Row(
          children: [
            Text(
              l10n.battle_page_player_deck_count_text,
              style: GoogleFonts.shareTechMono(fontSize: 12),
            ),
            Text(
              '${deckCount ?? 0}',
              style: GoogleFonts.shareTechMono(fontWeight: .bold),
            ),
          ],
        ),
      ],
    );
  }
}

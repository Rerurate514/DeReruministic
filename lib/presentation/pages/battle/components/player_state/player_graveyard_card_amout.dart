import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_card_amount_base.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class PlayerGraveyardCardAmount extends ConsumerWidget {
  const PlayerGraveyardCardAmount({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final graveyardCount = ref
        .watch(
          myPlayerUiStateProvider(player).select((s) => s?.graveyard),
        )
        ?.length;

    return PlayerCardAmount(
      icon: Symbols.delete,
      label: l10n.battle_page_player_graveyard_count_text,
      count: graveyardCount ?? 0,
      iconColor: theme.zoneGraveyard,
      painterColor: theme.brandSecondary,
    );
  }
}

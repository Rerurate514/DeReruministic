import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class EnemyStateCost extends ConsumerWidget {
  const EnemyStateCost({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final cost = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.cost),
    );

    final maxCost = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.maxCost),
    );

    if (cost == null || maxCost == null) return const UiLoadingIndicator();

    return Row(
      spacing: 4,
      children: [
        Icon(
          Symbols.bolt,
          color: theme.costDp,
          size: 20,
        ),
        Text(
          l10n.battle_page_header_cost(cost, maxCost),
          style: GoogleFonts.shareTechMono(fontSize: 20),
        ),
      ],
    );
  }
}

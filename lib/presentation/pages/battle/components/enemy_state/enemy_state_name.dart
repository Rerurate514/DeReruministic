import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnemyStateName extends ConsumerWidget {
  const EnemyStateName({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final name = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.name),
    );

    return Row(
      spacing: 4,
      children: [
        Icon(
          Symbols.warning,
          size: 16,
          color: theme.textSecondary,
        ),
        Text(
          name ?? l10n.game_state_is_null,
          style: GoogleFonts.poppins(color: theme.textSecondary, fontSize: 20),
        ),
      ],
    );
  }
}

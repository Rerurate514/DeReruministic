import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnemyStateShield extends ConsumerWidget {
  const EnemyStateShield({required this.enemy, super.key});
  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final shield = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.shield),
    );

    if (shield == null) return const UiLoadingIndicator();

    return FittedBox(
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        background: theme.surfaceContainer,
        child: Row(
          spacing: 4,
          children: [
            const Icon(
              Symbols.shield,
              size: 12,
            ),
            Text(
              '$shield',
              style: GoogleFonts.shareTechMono(
                fontWeight: .bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

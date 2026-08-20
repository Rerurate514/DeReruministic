import 'package:animated_text_effects/animated_text_effects.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_square.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            UiActiveFilledSquare(
              color: theme.brandColor,
              isOnlyBorder: true,
            ),
            Text(
              l10n.battle_page_opponent_id_text,
              style: GoogleFonts.poppins(
                color: theme.textSecondary.withAlpha(100),
              ),
            ),
          ],
        ),
        AnimatedText(
          name ?? l10n.game_state_is_null,
          effects: const [TypewriterErrorEffect()],
          style: GoogleFonts.shareTechMono(
            fontWeight: .bold,
            fontSize: 20,
            color: theme.brandTertiary,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

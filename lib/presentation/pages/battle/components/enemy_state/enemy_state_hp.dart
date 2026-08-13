import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/painter/hp_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EnemyStateHp extends ConsumerWidget {
  const EnemyStateHp({required this.enemy, super.key});
  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final hp = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.hp),
    );

    final maxHp = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.maxHp),
    );

    if (hp == null || maxHp == null) return const UiLoadingIndicator();

    return SizedBox(
      height: 32,
      child: Stack(
        alignment: .centerLeft,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: HpPainter(
                count: hp,
                max: maxHp,
                color: theme.enemyHp,
              ),
            ),
          ),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            background: theme.buttonSecondary.withAlpha(200),
            child: FittedBox(
              child: Text(
                l10n.battle_page_header_hp_bar(hp, maxHp),
                style: GoogleFonts.shareTechMono(fontWeight: .bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

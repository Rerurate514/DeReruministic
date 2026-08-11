import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
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
      height: 24,
      child: Stack(
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
          Text(
            l10n.battle_page_header_hp_bar(hp, maxHp),
            style: GoogleFonts.shareTechMono(fontWeight: .bold),
          ),
        ],
      ),
    );
  }
}

class HpPainter extends CustomPainter {
  const HpPainter({
    required this.count,
    required this.max,
    required this.color,
  });

  final int count;
  final int max;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (count <= 0) return;

    const gap = 4;
    final totalGap = gap * (max - 1);
    final rectWidth = (size.width - totalGap) / max;
    final hpPaint = Paint()..color = color;

    for (var i = 0; i < count; i++) {
      final left = i * (rectWidth + gap);
      final rect = Rect.fromLTWH(left, 0, rectWidth, size.height);
      canvas.drawRect(rect, hpPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HpPainter oldDelegate) {
    return oldDelegate.count != count;
  }
}

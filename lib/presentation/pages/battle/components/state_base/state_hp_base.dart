import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/painter/hp_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StateHpBase extends StatelessWidget {
  const StateHpBase({
    required this.hp,
    required this.maxHp,
    required this.isPlayer,
    super.key,
  });

  final int hp;
  final int maxHp;
  final bool isPlayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

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
                color: isPlayer ? theme.playerHp : theme.enemyHp,
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

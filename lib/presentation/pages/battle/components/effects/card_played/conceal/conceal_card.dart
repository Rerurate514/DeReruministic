import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_glow_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/state/card_state_component.dart';
import 'package:dereruministic/presentation/pages/battle/components/effects/card_played/conceal/conceal_card_meta.dart';
import 'package:dereruministic/presentation/pages/battle/components/effects/card_played/conceal/conceal_card_name_text.dart';
import 'package:dereruministic/presentation/painter/scanline_painter.dart';
import 'package:dereruministic/presentation/painter/under_card_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class ConcealCard extends StatelessWidget {
  const ConcealCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return SizedBox(
      width: 180,
      height: 240,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppGlowContainer(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Align(
                            child: CardStateComponent(
                              state: .conceal(),
                              runtimeStates: null,
                            ),
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: Text(l10n.battle_page_conceal_card_detail),
                        ),
                      ],
                    ),
                  ),
                  const Positioned.fill(
                    child: CustomPaint(
                      painter: ScanlinePainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(alignment: Alignment.topRight, child: ConcealCardMeta()),
          const Positioned(
            child: ConcealCardNameText(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomPaint(
              painter: UnderCardPainter(color: theme.brandSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

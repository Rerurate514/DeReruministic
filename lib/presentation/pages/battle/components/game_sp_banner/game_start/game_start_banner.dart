import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/data_link_status_row.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/header_protocol_text.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/main_title_text.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/terminal_access_row.dart';
import 'package:dereruministic/presentation/painter/corner_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class GameStartBanner extends StatelessWidget {
  const GameStartBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return SizedBox(
      height: 400,
      child: AppCard(
        isBlur: true,
        blurSigma: 10,
        padding: const EdgeInsets.all(32),
        child: CustomPaint(
          painter: CornerPainter(
            color: theme.brandSecondary,
            strokeWidth: 1.5,
            cornerLength: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox.shrink(),
              ),
              const HeaderProtocolText(),
              MainTitleText(color: theme.brandColor),
              TerminalAccessRow(color: theme.brandSecondary),
              Expanded(
                child: DataLinkStatusRow(color: theme.brandSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

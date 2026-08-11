import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/data_link_widget.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/sys_active_widget.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/turn_text.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class BattleHeader extends StatelessWidget {
  const BattleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return AppCard(
      borderWidth: 0.4,
      borderRadius: 8,
      padding: const EdgeInsets.all(4),
      borderColor: theme.brandSecondary,
      child: const Row(
        mainAxisAlignment: .spaceAround,
        children: [SysActiveWidget(), TurnNext(), DataLinkWidget()],
      ),
    );
  }
}

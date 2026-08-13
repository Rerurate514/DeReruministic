import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/data_link_widget.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/sys_active_widget.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/turn/game_phase_chip.dart';
import 'package:flutter/material.dart';

class BattleHeader extends StatelessWidget {
  const BattleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      borderWidth: 0.4,
      borderRadius: 8,
      padding: EdgeInsets.all(4),
      child: Stack(
        alignment: .center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                SysActiveWidget(),
                DataLinkWidget(),
              ],
            ),
          ),
          Center(
            child: GamePhaseChip(),
          ),
        ],
      ),
    );
  }
}

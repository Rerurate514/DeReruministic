import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_cost.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerCostSystemDescription extends StatelessWidget {
  const PlayerCostSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: 'PLAYER COST SYSTEM',
      titleColor: theme.costDp,
      leading: const Icon(Symbols.bolt),
      details: const Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(
            '''
コストはカードを使用するために必要なパラメータです。
ゲーム開始時の上限は4になります(これはバフやデバフなどで変動することがあります)。
ターン開始時には4、コストが回復します(これはバフやデバフなどで変動することがあります)。
コストが0になっても、使うことができるカードは存在しています。''',
          ),

          Padding(
            padding: EdgeInsets.only(left: 2, bottom: 8, right: 4),
            child: SizedBox(
              width: 150,
              child: StateCost(
                cost: 3,
                maxCost: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

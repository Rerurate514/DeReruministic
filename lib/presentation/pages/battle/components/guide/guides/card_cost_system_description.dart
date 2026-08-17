import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_card_cost.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_cost.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardCostSystemDescription extends StatelessWidget {
  const CardCostSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: 'CARD COST SYSTEM',
      titleColor: theme.costDp,
      leading: const Icon(Symbols.bolt_boost),
      details: const Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(
            '''
カードの右上にカードを使用するときに消費するコスト量を示しています。
自身の所持コストを超えるカードを使用することはできません。
またこの表記されているコストは変動することがあります。''',
          ),

          Wrap(
            crossAxisAlignment: .center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2, right: 4),
                child: SizedBox(
                  width: 50,
                  child: StateCardCost(
                    cost: 2,
                  ),
                ),
              ),
              Text('のコスト消費量のカードを'),
              Padding(
                padding: EdgeInsets.only(left: 2, right: 4),
                child: SizedBox(
                  width: 116,
                  child: StateCost(
                    cost: 1,
                    maxCost: 4,
                  ),
                ),
              ),
              Text('の時に使用することはできません。'),
            ],
          ),
        ],
      ),
    );
  }
}

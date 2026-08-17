import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_hp_base.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HpSystemDescription extends StatelessWidget {
  const HpSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: 'HP SYSTEM',
      titleColor: theme.playerHp,
      leading: const Icon(Symbols.heart_plus),
      details: const Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(
            '''
HPシステムはとても単純なHPとして表されています。画面下のこのHPバーが数値を視覚的に表しています。線の数は現在のHPと一致しています。このHPが0になると敗北となります。''',
          ),

          Padding(
            padding: EdgeInsets.only(left: 2, bottom: 8, right: 4),
            child: SizedBox(
              width: double.infinity,
              child: StateHpBase(
                hp: 75,
                maxHp: 100,
                isPlayer: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

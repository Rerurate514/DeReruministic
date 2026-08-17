import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_hp_base.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_shield_base.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShieldSystemDescription extends StatelessWidget {
  const ShieldSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: 'SHIELD SYSTEM',
      titleColor: theme.shield,
      leading: const Icon(Symbols.shield),
      details: const Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(
            '''
シールドはHPの右に表記されています。シールド数値の上限はありません。これは自分のターンが開始する際に0に毎回リセットされます。シールドの数値を超えてダメージを受けた場合は、超過分がHPのダメージとして計算されます。''',
          ),

          Wrap(
            crossAxisAlignment: .center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2, right: 4),
                child: SizedBox(
                  height: 32,
                  child: StateShieldBase(
                    shield: 10,
                  ),
                ),
              ),

              Text('シールドの時に20ダメージを受けると、10ダメージはシールドが肩代わりして、HPは10ダメージを受ける。'),

              Icon(Symbols.arrow_right_alt),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: SizedBox(
                  width: 120,
                  child: StateHpBase(
                    hp: 90,
                    maxHp: 100,
                    isPlayer: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

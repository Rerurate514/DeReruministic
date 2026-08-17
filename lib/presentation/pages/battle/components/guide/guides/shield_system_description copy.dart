import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/state_status.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state_hp.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state_shield.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShieldSystemDescription extends StatelessWidget {
  const ShieldSystemDescription({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: 'SHIELD SYSTEM',
      titleColor: theme.shield,
      leading: const Icon(Symbols.shield),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          const Text(
            '''
シールドはHPの右に表記されています。シールド数値の上限はありません。これは自分のターンが開始する際に0に毎回リセットされます。シールドの数値を超えてダメージを受けた場合は、超過分がHPのダメージとして計算されます。''',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 4, right: 4),
            child: SizedBox(
              width: double.infinity,
              child: StateStatus(
                hpStateWidget: PlayerStateHp(
                  player: player,
                ),
                shieldStateWidget: PlayerStateShield(
                  player: player,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

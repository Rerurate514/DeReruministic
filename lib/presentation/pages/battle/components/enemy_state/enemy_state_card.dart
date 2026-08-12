import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/state_status.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_cost.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_hp.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_name.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_shield.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';

class EnemyStateCard extends StatelessWidget {
  const EnemyStateCard({required this.enemy, super.key});
  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppCard(
        borderRadius: 4,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                EnemyStateName(enemy: enemy),
                EnemyStateCost(
                  enemy: enemy,
                ),
              ],
            ),
            const UiGap.xs(),
            StateStatus(
              hpStateWidget: EnemyStateHp(
                enemy: enemy,
              ),
              shieldStateWidget: EnemyStateShield(
                enemy: enemy,
              ),
            ),
            // EnemyStateBuffs(enemy: enemy),
            // EnemyStateDebuffs(enemy: enemy),
            // EnemyStateCost(enemy: enemy),
          ],
        ),
      ),
    );
  }
}

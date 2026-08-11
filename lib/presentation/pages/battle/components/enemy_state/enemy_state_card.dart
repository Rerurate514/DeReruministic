import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_hp.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_name.dart';
import 'package:flutter/material.dart';

class EnemyStateCard extends StatelessWidget {
  const EnemyStateCard({required this.enemy, super.key});
  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          EnemyStateName(enemy: enemy),
          EnemyStateHp(enemy: enemy),
          // EnemyStateBuffs(enemy: enemy),
          // EnemyStateDebuffs(enemy: enemy),
          // EnemyStateCost(enemy: enemy),
          // EnemyStateShield(enemy: enemy),
        ],
      ),
    );
  }
}

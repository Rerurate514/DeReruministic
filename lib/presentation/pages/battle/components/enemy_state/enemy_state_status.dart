import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_hp.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_shield.dart';
import 'package:flutter/material.dart';

class EnemyStateStatus extends StatelessWidget {
  const EnemyStateStatus({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: EnemyStateHp(
            enemy: enemy,
          ),
        ),
        Align(
          alignment: .centerEnd,
          child: EnemyStateShield(
            enemy: enemy,
          ),
        ),
      ],
    );
  }
}

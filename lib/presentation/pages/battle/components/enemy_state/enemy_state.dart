import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_card.dart';
import 'package:flutter/widgets.dart';

class EnemyState extends StatelessWidget {
  const EnemyState({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return EnemyStateCard(
      enemy: enemy,
    );
  }
}

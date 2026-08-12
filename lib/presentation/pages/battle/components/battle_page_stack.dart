import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state.dart';
import 'package:dereruministic/presentation/pages/battle/components/phase/phase_banner_animation_container.dart';
import 'package:flutter/widgets.dart';

class BattlePageStack extends StatelessWidget {
  const BattlePageStack({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: EnemyState(
            enemy: enemy,
          ),
        ),
        const Align(
          alignment: Alignment(0, 0.3),
          child: PhaseBannerAnimationContainer(),
        ),
      ],
    );
  }
}

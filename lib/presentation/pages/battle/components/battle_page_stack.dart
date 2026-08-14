import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/drag_area/card_drag_area.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state.dart';
import 'package:dereruministic/presentation/pages/battle/components/hand/hand_component.dart';
import 'package:dereruministic/presentation/pages/battle/components/phase/phase_banner_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BattlePageStack extends StatelessWidget {
  const BattlePageStack({required this.player, required this.enemy, super.key});

  final Player player;
  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            EnemyState(
              enemy: enemy,
            ),
            const Expanded(child: CardDragArea()),
            PlayerState(
              player: player,
            ),
            HandComponent(
              player: player,
            ),
          ],
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: PhaseBannerAnimationContainer(),
        ),
      ],
    );
  }
}

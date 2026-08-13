import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_component.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state.dart';
import 'package:dereruministic/presentation/pages/battle/components/phase/phase_banner_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state.dart';
import 'package:flutter/widgets.dart';

class BattlePageStack extends StatelessWidget {
  const BattlePageStack({required this.player, required this.enemy, super.key});

  final Player player;
  final Player enemy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: .topCenter,
          child: EnemyState(
            enemy: enemy,
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: PhaseBannerAnimationContainer(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PlayerState(
            player: player,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: GameCardComponent(
            defId: player.hand.first,
          ),
        ),
      ],
    );
  }
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/background/background_logs.dart';
import 'package:dereruministic/presentation/pages/battle/components/drag_area/card_drag_area.dart';
import 'package:dereruministic/presentation/pages/battle/components/end_turn/_test_end_enemy_turn_button.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/game_start_banner_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/tactical_guide_switcher.dart';
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
        const Align(
          alignment: Alignment.centerLeft,
          child: BackgroundLogs(),
        ),
        Column(
          children: [
            EnemyState(
              enemy: enemy,
            ),
            Expanded(
              child: CardDragArea(
                player: player,
              ),
            ),
            PlayerState(
              player: player,
            ),
            HandComponent(
              player: player,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: PhaseBannerAnimationContainer(
            player: player,
          ),
        ),
        const Align(
          child: GameStartBannerAnimationContainer(),
        ),
        Align(
          alignment: .topRight,
          child: TestEndEnemyTurnButton(
            playerId: player.id,
          ),
        ),
        Positioned.fill(
          child: TacticalGuideSwitcher(
            player: player,
          ),
        ),
      ],
    );
  }
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/background/background_logs.dart';
import 'package:dereruministic/presentation/pages/battle/components/background/background_text_lines.dart';
import 'package:dereruministic/presentation/pages/battle/components/drag_area/card_drag_area.dart';
import 'package:dereruministic/presentation/pages/battle/components/effects/card_played/card_played_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state.dart';
import 'package:dereruministic/presentation/pages/battle/components/event_log/event_log_switcher.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_end/game_end_banner_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/game_start_banner_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/tactical_guide_switcher.dart';
import 'package:dereruministic/presentation/pages/battle/components/hand/hand_component.dart';
import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/in_discard_card_remove_area.dart';
import 'package:dereruministic/presentation/pages/battle/components/overflowed_discard_area/overflowed_discard_area_switcher.dart';
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
        const Positioned.fill(
          child: BackgroundTextLines(),
        ),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
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
                      ],
                    ),
                    const Align(
                      child: OverflowedDiscardAreaSwitcher(),
                    ),
                  ],
                ),
              ),

              Stack(
                children: [
                  HandComponent(
                    player: player,
                  ),
                  const Positioned.fill(
                    child: InDiscardCardRemoveArea(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: PhaseBannerAnimationContainer(
            player: player,
          ),
        ),

        const Align(
          child: CardPlayedAnimationContainer(),
        ),

        const Align(
          child: GameStartBannerAnimationContainer(),
        ),
        const Align(
          child: GameEndBannerAnimationContainer(),
        ),
        const Positioned.fill(
          child: TacticalGuideSwitcher(),
        ),
        const Positioned.fill(
          child: EventLogSwitcher(),
        ),
      ],
    );
  }
}

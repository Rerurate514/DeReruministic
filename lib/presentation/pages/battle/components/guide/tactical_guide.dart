import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_header.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/hp_system_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/player_cost_system_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/shield_system_description%20copy.dart';
import 'package:flutter/material.dart';

class TacticalGuide extends StatelessWidget {
  const TacticalGuide({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AppCard(
        padding: const EdgeInsets.all(8),
        isBlur: true,
        blurSigma: 10,
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              const Column(
                children: [
                  GuideHeader(),
                  Divider(),
                ],
              ),
              HpSystemDescription(
                player: player,
              ),
              ShieldSystemDescription(player: player),
              PlayerCostSystemDescription(
                player: player,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

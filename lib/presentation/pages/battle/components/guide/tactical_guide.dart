import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_header.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/hp_system_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/player_cost_system_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/shield_system_description%20copy.dart';
import 'package:flutter/material.dart';

class TacticalGuide extends StatelessWidget {
  const TacticalGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: AppCard(
        padding: EdgeInsets.all(8),
        isBlur: true,
        blurSigma: 10,
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Column(
                children: [
                  GuideHeader(),
                  Divider(),
                ],
              ),
              HpSystemDescription(),
              ShieldSystemDescription(),
              PlayerCostSystemDescription(),
            ],
          ),
        ),
      ),
    );
  }
}

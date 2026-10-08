import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/state_effect_list.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/status_effect_chip.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnemyStateBuffs extends ConsumerWidget {
  const EnemyStateBuffs({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buffs = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((state) => state?.buffs),
    );

    if (buffs == null) return const SizedBox.shrink();

    return StateEffectList(
      effects: buffs
          .map((state) => StatusEffectChip.buff(state: state))
          .toList(),
    );
  }
}

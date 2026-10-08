import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/state_effect_list.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/status_effect_chip.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnemyStateDebuffs extends ConsumerWidget {
  const EnemyStateDebuffs({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debuffs = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((state) => state?.debuffs),
    );

    if (debuffs == null) return const SizedBox.shrink();

    return StateEffectList(
      effects: debuffs
          .map((state) => StatusEffectChip.debuff(state: state))
          .toList(),
    );
  }
}

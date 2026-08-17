import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_cost.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnemyStateCost extends ConsumerWidget {
  const EnemyStateCost({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cost = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.cost),
    );

    final maxCost = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.maxCost),
    );

    if (cost == null || maxCost == null) return const UiLoadingIndicator();

    return StateCost(
      cost: cost,
      maxCost: maxCost,
    );
  }
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_cost.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_cost_calculated_notifier.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStateCost extends ConsumerWidget {
  const PlayerStateCost({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cost = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.cost),
    );

    final maxCost = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.maxCost),
    );

    if (cost == null || maxCost == null) return const UiLoadingIndicator();

    final event = ref.watch(displayedCostCalculatedProvider);

    return StateCost(
      cost: event != null ? cost : 0,
      maxCost: maxCost,
    );
  }
}

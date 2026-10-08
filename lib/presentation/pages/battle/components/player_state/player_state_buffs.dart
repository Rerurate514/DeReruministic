import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/state_effect_list.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/status_effect_chip.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStateBuffs extends ConsumerWidget {
  const PlayerStateBuffs({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buffs = ref.watch(
      myPlayerUiStateProvider(player).select((state) => state?.buffs),
    );

    if (buffs == null) return const SizedBox.shrink();

    return StateEffectList(
      effects: buffs
          .map((state) => StatusEffectChip.buff(state: state))
          .toList(),
    );
  }
}

import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/state_effect_list.dart';
import 'package:dereruministic/presentation/pages/battle/components/common/status_effect_chip.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStateDebuffs extends ConsumerWidget {
  const PlayerStateDebuffs({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debuffs = ref.watch(
      myPlayerUiStateProvider(player).select((state) => state?.debuffs),
    );

    if (debuffs == null) return const SizedBox.shrink();

    return StateEffectList(
      effects: debuffs
          .map((state) => StatusEffectChip.debuff(state: state))
          .toList(),
    );
  }
}

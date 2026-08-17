import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_hp_base.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnemyStateHp extends ConsumerWidget {
  const EnemyStateHp({required this.enemy, super.key});
  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hp = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.hp),
    );

    final maxHp = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.maxHp),
    );

    if (hp == null || maxHp == null) return const UiLoadingIndicator();

    return StateHpBase(
      hp: hp,
      maxHp: maxHp,
      isPlayer: false,
    );
  }
}

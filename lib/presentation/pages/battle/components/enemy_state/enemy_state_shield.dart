import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_shield_base.dart';
import 'package:dereruministic/presentation/pages/battle/providers/enemy_ui_state_provider.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnemyStateShield extends ConsumerWidget {
  const EnemyStateShield({required this.enemy, super.key});
  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shield = ref.watch(
      enemyPlayerUiStateProvider(enemy).select((s) => s?.shield),
    );

    if (shield == null) return const UiLoadingIndicator();

    return StateShieldBase(
      shield: shield,
    );
  }
}

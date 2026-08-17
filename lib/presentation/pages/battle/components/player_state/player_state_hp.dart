import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_hp_base.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerStateHp extends ConsumerWidget {
  const PlayerStateHp({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hp = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.hp),
    );

    final maxHp = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.maxHp),
    );

    if (hp == null || maxHp == null) return const UiLoadingIndicator();

    return StateHpBase(
      hp: hp,
      maxHp: maxHp,
      isPlayer: true,
    );
  }
}

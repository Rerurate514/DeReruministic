import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/battle_header.dart';
import 'package:dereruministic/presentation/pages/battle/components/phase/phase_banner_animation_container.dart';
import 'package:dereruministic/presentation/pages/battle/debug/use_debug_step_consumer.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BattlePage extends HookConsumerWidget {
  const BattlePage({
    required this.playerA,
    required this.playerB,
    required this.seed,
    super.key,
  });

  final Player playerA;
  final Player playerB;
  final int seed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(gameProvider.notifier).startGame(playerA, playerB, seed);
      });
      return null;
    }, []);

    useDebugStepConsumer(ref: ref, enabled: kDebugMode);

    return UiPageWrapper(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const BattleHeader(),
          EnemyStateCard(
            enemy: playerB,
          ),
          const PhaseBannerAnimationContainer(),
        ],
      ),
    );
  }
}

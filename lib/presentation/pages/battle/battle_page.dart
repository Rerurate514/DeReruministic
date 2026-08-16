import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/battle_page_stack.dart';
import 'package:dereruministic/presentation/pages/battle/components/end_turn/end_turn_button.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/battle_header.dart';
import 'package:dereruministic/presentation/pages/battle/debug/ues_debug_enemy_step_consumer.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/event_step_driver_notifier.dart';
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

    useDebugEnemyStepConsumer(ref: ref, id: playerA.id, enabled: kDebugMode);

    ref
      ..watch(eventStepDriverProvider(playerA.id))
      ..watch(animationSignalProvider);

    return UiPageWrapper(
      padding: const EdgeInsets.all(4),
      floatingActionButton: EndTurnButton(
        playerId: playerA.id,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const BattleHeader(),
          Expanded(
            child: BattlePageStack(
              player: playerA,
              enemy: playerB,
            ),
          ),
        ],
      ),
    );
  }
}

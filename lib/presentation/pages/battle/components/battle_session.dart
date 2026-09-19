import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/remote_sync/in_game/usecases/end_game_usecase.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:dereruministic/presentation/pages/battle/components/battle_page_stack.dart';
import 'package:dereruministic/presentation/pages/battle/components/end_turn/end_turn_button.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/battle_header.dart';
import 'package:dereruministic/presentation/pages/battle/debug/ues_debug_enemy_step_consumer.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/battle_end_navigation_coordinator_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/event_step_driver_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/event_step_log_notifier.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BattleSession extends HookConsumerWidget {
  const BattleSession({
    required this.room,
    required this.player,
    required this.enemy,
    required this.isHost,
    super.key,
  });

  final Room room;
  final Player player;
  final Player enemy;
  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (isHost) {
          await ref
              .read(gameProvider.notifier)
              .startGame(
                room.roomId,
                player,
                enemy,
              );
        } else {
          ref.read(gameProvider.notifier).joinGame(room.roomId);
        }
      });
      return null;
    }, []);

    useEffect(() {
      final subs = [
        ref.listenManual(battleEndNavigationCoordinatorProvider, (_, n) async {
          if (n) {
            await ref.read(endGameUseCaseProvider).execute(roomId: room.roomId);
            if (!context.mounted) return;
            context.goNamed(
              RouterPaths.room.name,
              pathParameters: {
                'roomId': room.roomId.value,
              },
            );
          }
        }),
        ref.listenManual(eventStepDriverProvider(player.id), (_, _) {}),
        ref.listenManual(animationSignalProvider, (_, _) {}),
        ref.listenManual(eventStepLogProvider, (_, _) {}),
      ];

      return () {
        for (final s in subs) {
          s.close();
        }
      };
    }, []);

    useDebugEnemyStepConsumer(
      ref: ref,
      id: player.id,
      enabled: kDebugMode,
    );

    return UiPageWrapper(
      padding: const EdgeInsets.all(4),
      floatingActionButton: EndTurnButton(playerId: player.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BattleHeader(),
          Expanded(
            child: BattlePageStack(
              player: player,
              enemy: enemy,
            ),
          ),
        ],
      ),
    );
  }
}

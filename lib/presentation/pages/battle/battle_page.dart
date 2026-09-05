import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/application/user/state/player_profile.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/presentation/pages/battle/components/battle_page_stack.dart';
import 'package:dereruministic/presentation/pages/battle/components/end_turn/end_turn_button.dart';
import 'package:dereruministic/presentation/pages/battle/components/header/battle_header.dart';
import 'package:dereruministic/presentation/pages/battle/debug/ues_debug_enemy_step_consumer.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/event_step_driver_notifier.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BattlePage extends HookConsumerWidget {
  const BattlePage({required this.roomId, super.key});
  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomData = ref.watch(roomWatchProvider(roomId: roomId));
    final player = ref.watch(currentUserProfileProvider);

    return roomData.when(
      data: (data) {
        switch (data) {
          case RoomWatchResultAvailable(:final room):
            {
              final isHost = player.id == room.hostPlayerId;
              final enemy = ref.watch(
                playerProfileProvider(
                  isHost ? room.guestPlayerId! : room.hostPlayerId,
                ),
              );

              useEffect(() {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (isHost) {
                    await ref
                        .read(gameProvider.notifier)
                        .startGame(room.roomId, player, enemy);
                  }
                });
                return null;
              }, []);

              ref
                ..watch(eventStepDriverProvider(player.id))
                ..watch(animationSignalProvider);

              useDebugEnemyStepConsumer(
                ref: ref,
                id: player.id,
                enabled: kDebugMode,
              );

              return UiPageWrapper(
                padding: const EdgeInsets.all(4),
                floatingActionButton: EndTurnButton(
                  playerId: player.id,
                ),
                child: Column(
                  crossAxisAlignment: .stretch,
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
          case RoomWatchResultUnavailable():
            throw UnimplementedError();
        }
      },
      error: (error, stackTrace) => Text('$error, $stackTrace'),
      loading: UiLoadingIndicator.new,
    );
  }
}

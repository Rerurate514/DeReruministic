import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battle_end_navigation_coordinator_notifier.g.dart';

@riverpod
class BattleEndNavigationCoordinatorNotifier
    extends _$BattleEndNavigationCoordinatorNotifier {
  @override
  bool build() {
    final isEndPhase = ref.watch(
      gameProvider.select((s) => s?.phase.battlePhase == .battleEnd),
    );
    final isEmpty = ref.watch(stepEventQueueProvider.select((s) => s.isEmpty));

    return isEndPhase && isEmpty;
  }
}

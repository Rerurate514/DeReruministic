import 'package:dereruministic/application/game/state/consumed_step_event_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battle_end_navigation_coordinator_notifier.g.dart';

@riverpod
class BattleEndNavigationCoordinatorNotifier
    extends _$BattleEndNavigationCoordinatorNotifier {
  @override
  bool build() {
    ref.listen(consumedStepEventProvider, (_, step) {
      if (step case GameStepEventGameEnded()) {
        state = true;
        ref.read(stepEventQueueProvider.notifier).clear();
      }
    });

    return false;
  }
}

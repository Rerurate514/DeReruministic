import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_game_start_notifier.g.dart';

@riverpod
class DisplayedGameStartNotifier extends _$DisplayedGameStartNotifier {
  @override
  bool build() {
    ref.listen(stepEventQueueProvider, (_, next) {
      if (next.isEmpty) return;

      final currentEvent = next.first;
      if (currentEvent is GameStepEventGameStarted) {
        state = true;
      }
    });

    return false;
  }

  void setFalse() {
    state = false;
  }
}

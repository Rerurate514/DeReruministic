import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_overflow_check_triggered_notifier.g.dart';

@riverpod
class DisplayedOverflowCheckTriggeredNotifier
    extends _$DisplayedOverflowCheckTriggeredNotifier {
  @override
  GameStepEvent? build() => null;

  void apply() {
    final step = ref.read(stepEventQueueProvider);
    if (step.isEmpty) {
      state = null;
      return;
    }
    if (step.first is! GameStepEventOverflowCheckTriggered) {
      state = null;
      return;
    }

    state = step.first;
  }
}

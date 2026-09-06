import 'package:collection/collection.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_step_log_notifier.g.dart';

@riverpod
class EventStepLogNotifier extends _$EventStepLogNotifier {
  @override
  QueueList<GameStepEvent> build() {
    ref.listen(stepEventQueueProvider, (p, n) {
      if (p == null || n.length >= p.length) return;

      final removedCount = p.length - n.length;
      final consumedEvents = p.take(removedCount);

      state = QueueList.from(state)..addAll(consumedEvents);
    });

    return QueueList.from([]);
  }
}

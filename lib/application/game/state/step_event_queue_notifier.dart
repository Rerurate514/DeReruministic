import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step_event_queue_notifier.g.dart';

@riverpod
class StepEventQueueNotifier extends _$StepEventQueueNotifier {
  @override
  List<GameStepEvent> build() {
    return [];
  }

  void enqueueAll(List<GameStepEvent> steps) {
    state = [...state, ...steps];
  }

  void consumeCurrentStep() {
    if (state.isEmpty) return;
    state = state.sublist(1);
  }

  void clear() {
    state = [];
  }
}

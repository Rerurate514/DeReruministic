import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_card_drawn_notifier.g.dart';

@riverpod
class DisplayedCardDrawnNotifier extends _$DisplayedCardDrawnNotifier {
  @override
  GameStepEvent? build() => null;

  void apply() {
    final step = ref.read(stepEventQueueProvider);
    if (step.isEmpty) {
      state = null;
      return;
    }
    if (step.first is! GameStepEventCardsDrawn) {
      state = null;
      return;
    }

    state = step.first;
  }
}

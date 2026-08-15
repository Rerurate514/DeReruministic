import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_phase_notifier.g.dart';

@riverpod
class DisplayedPhaseNotifier extends _$DisplayedPhaseNotifier {
  @override
  GamePhase? build() {
    ref.listen(stepEventQueueProvider, (_, next) {
      if (next.isEmpty) return;

      final currentEvent = next.first;
      if (currentEvent is GameStepEventPhaseChanged) {
        state = currentEvent.phase;
      }
    });

    return ref.read(gameProvider)?.phase;
  }
}

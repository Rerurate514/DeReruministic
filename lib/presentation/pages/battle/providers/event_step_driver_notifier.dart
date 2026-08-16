import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/presentation/pages/battle/executors/step_event_executor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_step_driver_notifier.g.dart';

@riverpod
class EventStepDriverNotifier extends _$EventStepDriverNotifier {
  PlayerId? _playerId;
  bool _running = false;

  @override
  void build(PlayerId id) {
    _playerId = id;
    ref.listen(stepEventQueueProvider.select((s) => s.isNotEmpty), (
      _,
      hasItems,
    ) {
      if (hasItems) _pump();
    }, fireImmediately: true);

    return;
  }

  Future<void> _pump() async {
    if (_running) return;
    if (_playerId == null) return;

    _running = true;

    try {
      while (true) {
        if (!ref.mounted) return;

        final queue = ref.read(stepEventQueueProvider);
        if (queue.isEmpty) return;

        await ref
            .read(stepEventExecutorProvider(_playerId!))
            .execute(queue.first);

        if (!ref.mounted) return;

        ref.read(stepEventQueueProvider.notifier).consumeCurrentStep();
      }
    } finally {
      _running = false;
    }
  }
}

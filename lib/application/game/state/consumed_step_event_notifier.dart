import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consumed_step_event_notifier.g.dart';

@riverpod
class ConsumedStepEventNotifier extends _$ConsumedStepEventNotifier {
  @override
  GameStepEvent? build() => null;

  void notify(GameStepEvent step) => state = step;
}

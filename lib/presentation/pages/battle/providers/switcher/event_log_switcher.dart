import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_log_switcher.g.dart';

@riverpod
class EventLogSwitcher extends _$EventLogSwitcher {
  @override
  bool build() {
    return false;
  }

  void toggle() => state = !state;
}

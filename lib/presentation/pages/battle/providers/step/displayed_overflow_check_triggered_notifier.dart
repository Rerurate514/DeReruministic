import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_overflow_check_triggered_notifier.g.dart';

@riverpod
class DisplayedOverflowCheckTriggeredNotifier
    extends _$DisplayedOverflowCheckTriggeredNotifier {
  @override
  int? build() {
    return 0;
  }

  void apply(int overflowCount) => state = overflowCount;
  void clear() => state = null;
}

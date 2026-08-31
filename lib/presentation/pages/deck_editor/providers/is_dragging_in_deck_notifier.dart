import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_dragging_in_deck_notifier.g.dart';

@riverpod
class IsDraggingInDeck extends _$IsDraggingInDeck {
  @override
  bool build() {
    return false;
  }

  void startDragging() {
    state = true;
  }

  void endDragging() {
    state = false;
  }
}

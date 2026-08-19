import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_game_end_notifier.g.dart';

@riverpod
class DisplayedGameEndNotifier extends _$DisplayedGameEndNotifier {
  @override
  bool build() => false;

  void apply() => state = true;

  void setFalse() {
    state = false;
  }
}

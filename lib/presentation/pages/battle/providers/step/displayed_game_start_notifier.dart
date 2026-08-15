import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_game_start_notifier.g.dart';

@riverpod
class DisplayedGameStartNotifier extends _$DisplayedGameStartNotifier {
  @override
  bool build() => false;

  void apply() => state = true;

  void setFalse() {
    state = false;
  }
}

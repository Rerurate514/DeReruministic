import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guide_switcher.g.dart';

@riverpod
class GuideSwitcher extends _$GuideSwitcher {
  @override
  bool build() {
    return false;
  }

  void toggle() => state = !state;
}

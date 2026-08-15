import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'animation_signal_notifier.g.dart';

@riverpod
class AnimationSignalNotifier extends _$AnimationSignalNotifier {
  Completer<void>? _completer;

  @override
  void build() {
    ref.onDispose(() => _completer?.complete());
  }

  Future<void> wait() async {
    _completer?.complete();

    return (_completer = Completer<void>()).future;
  }

  void done() {
    _completer?.complete();
    _completer = null;
  }
}

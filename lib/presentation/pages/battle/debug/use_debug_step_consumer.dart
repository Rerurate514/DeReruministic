// デバッグ用の自動ステップ消費フック
import 'dart:async';

import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void useDebugStepConsumer({
  required WidgetRef ref,
  bool enabled = false,
  Duration interval = const Duration(seconds: 1),
}) {
  useEffect(() {
    if (!enabled) return null;

    final timer = Timer.periodic(interval, (_) {
      final queue = ref.read(stepEventQueueProvider);
      if (queue.isNotEmpty) {
        debugPrint('🐛 [DebugAutoConsume] Event: ${queue.first.runtimeType}');
        ref.read(stepEventQueueProvider.notifier).consumeCurrentStep();
      }
    });

    return timer.cancel;
  }, [enabled, interval]);
}

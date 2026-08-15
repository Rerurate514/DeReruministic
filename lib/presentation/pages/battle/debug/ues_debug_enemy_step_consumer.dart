// デバッグ用の自動ステップ消費フック
import 'dart:async';

import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void useDebugEnemyStepConsumer({
  required WidgetRef ref,
  required PlayerId id,
  bool enabled = false,
  Duration interval = const Duration(seconds: 1),
}) {
  useEffect(() {
    if (!enabled) return null;

    final timer = Timer.periodic(interval, (_) {
      final queue = ref.read(stepEventQueueProvider);
      if (queue.isEmpty) return;
      final step = queue.first;
      if (step is! GameStepEventCardsDrawn) return;
      if (step.playerId == id) return;
      debugPrint('🐛 [DebugAutoConsume] Enemy Step Event: ${step.runtimeType}');
      ref.read(animationSignalProvider.notifier).done();
    });

    return timer.cancel;
  }, [enabled, interval]);
}

import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_card_drawn_provider.g.dart';

@riverpod
GameStepEvent? displayedCardDrawnEvent(Ref ref) {
  final step = ref.watch(stepEventQueueProvider);
  if (step.isEmpty) return null;
  if (step.first is! GameStepEventCardsDrawn) return null;

  return step.first;
}

@riverpod
GameStepEvent? displayedCardDrawnEventForPlayer(Ref ref, PlayerId id) {
  final step = ref.watch(displayedCardDrawnEventProvider);
  if (step == null) return null;
  if (step is! GameStepEventCardsDrawn) return null;
  if (step.playerId != id) return null;

  return step;
}

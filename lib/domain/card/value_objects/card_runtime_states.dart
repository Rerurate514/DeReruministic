import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_runtime_states.freezed.dart';
part 'card_runtime_states.g.dart';

@freezed
sealed class CardRuntimeStates with _$CardRuntimeStates {
  const factory CardRuntimeStates.recycle({
    required int remainingCount,
  }) = CardRuntimeStateRecycleState;

  const factory CardRuntimeStates.countdown({
    required int remainingTurns,
  }) = CardRuntimeStateTimerState;

  const factory CardRuntimeStates.decay({
    required int remainingTurns,
  }) = CardRuntimeStateDecayState;

  const factory CardRuntimeStates.retain({
    required int turnsInHand,
  }) = CardRuntimeStateRetainState;

  factory CardRuntimeStates.fromJson(Map<String, dynamic> json) =>
      _$CardRuntimeStatesFromJson(json);
}

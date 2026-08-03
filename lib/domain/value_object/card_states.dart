import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_states.freezed.dart';
part 'card_states.g.dart';

@freezed
sealed class CardStates with _$CardStates {
  const factory CardStates.exhaust() = CardStateExhaust;

  const factory CardStates.undiscardable() = CardStateUndiscardable;

  const factory CardStates.recycle({
    int? count,
  }) = CardStateRecycle;

  const factory CardStates.overload({
    required int amount,
  }) = CardStateOverload;

  const factory CardStates.conceal() = CardStateConceal;

  const factory CardStates.retain({
    required int turnThreshold,
    required int costReduction,
  }) = CardStateRetain;

  const factory CardStates.engrave({
    required String subTypeEffect,
  }) = CardStateEngrave;

  const factory CardStates.chain({
    required String subTypeEffect,
    required int order,
  }) = CardStateChain;

  const factory CardStates.countdown({
    required int turns,
  }) = CardStateCountdown;

  const factory CardStates.decay({
    required int turns,
  }) = CardStateDecay;

  const factory CardStates.infect() = CardStateInfect;

  factory CardStates.fromJson(Map<String, dynamic> json) =>
      _$CardStatesFromJson(json);
}

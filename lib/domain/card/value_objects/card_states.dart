import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_states.freezed.dart';
part 'card_states.g.dart';

@freezed
sealed class CardStates with _$CardStates {
  //焼却
  const factory CardStates.exhaust() = CardStateExhaust;

  //停滞
  const factory CardStates.undiscardable() = CardStateUndiscardable;

  //循環
  const factory CardStates.recycle({
    int? count,
  }) = CardStateRecycle;

  //反動
  const factory CardStates.overload({
    required int amount,
  }) = CardStateOverload;

  //潜伏
  const factory CardStates.conceal() = CardStateConceal;

  //保留
  const factory CardStates.retain({
    required int turnThreshold,
    required int costReduction,
  }) = CardStateRetain;

  //刻印
  const factory CardStates.engrave({
    required String subTypeEffect,
  }) = CardStateEngrave;

  //連携
  const factory CardStates.chain({
    required String subTypeEffect,
    required int order,
  }) = CardStateChain;

  //時限
  const factory CardStates.countdown({
    required int turns,
  }) = CardStateCountdown;

  //腐敗
  const factory CardStates.decay({
    required int turns,
  }) = CardStateDecay;

  //感染
  const factory CardStates.infect() = CardStateInfect;

  factory CardStates.fromJson(Map<String, dynamic> json) =>
      _$CardStatesFromJson(json);
}

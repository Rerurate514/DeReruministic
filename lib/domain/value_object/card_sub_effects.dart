import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_sub_effects.freezed.dart';
part 'card_sub_effects.g.dart';

@freezed
sealed class CardSubEffects with _$CardSubEffects {
  const factory CardSubEffects.exhaust() = CardSubEffectExhaust;

  const factory CardSubEffects.undiscardable() = CardSubEffectUndiscardable;

  const factory CardSubEffects.recycle({
    int? count,
  }) = CardSubEffectRecycle;

  const factory CardSubEffects.overload({
    required int amount,
  }) = CardSubEffectOverload;

  const factory CardSubEffects.conceal() = CardSubEffectConceal;

  const factory CardSubEffects.retain({
    required int turnThreshold,
    required int costReduction,
  }) = CardSubEffectRetain;

  const factory CardSubEffects.engrave({
    required String subTypeEffect,
  }) = CardSubEffectEngrave;

  const factory CardSubEffects.chain({
    required String subTypeEffect,
    required int order,
  }) = CardSubEffectChain;

  const factory CardSubEffects.countdown({
    required int turns,
  }) = CardSubEffectCountdown;

  const factory CardSubEffects.decay({
    required int turns,
  }) = CardSubEffectDecay;

  const factory CardSubEffects.infect() = CardSubEffectInfect;

  factory CardSubEffects.fromJson(Map<String, dynamic> json) =>
      _$CardSubEffectsFromJson(json);
}

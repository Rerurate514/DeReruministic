import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_effects_details.freezed.dart';
part 'card_effects_details.g.dart';

@freezed
sealed class CardEffectsDetails with _$CardEffectsDetails {
  const factory CardEffectsDetails({
    required CardEffects cardEffect,
    required EffectConditions effectCondition,
  }) = _CardEffectsDetails;

  factory CardEffectsDetails.fromJson(Map<String, dynamic> json) =>
      _$CardEffectsDetailsFromJson(json);
}

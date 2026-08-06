import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_effects.freezed.dart';
part 'card_effects.g.dart';

@freezed
sealed class CardEffects with _$CardEffects {
  const factory CardEffects.damage({
    required int amount,
    required CardTargetTypes target,
  }) = CardEffectDamage;

  const factory CardEffects.draw({
    required int amount,
  }) = CardEffectDraw;

  const factory CardEffects.discard({required GameCard card}) =
      CardEffectDiscard;

  const factory CardEffects.fetchCard({required GameCard card}) =
      CardEffectFetchCard;

  const factory CardEffects.heal({
    required int amount,
    required CardTargetTypes target,
  }) = CardEffectHeal;

  const factory CardEffects.grantShield({
    required int amount,
    required CardTargetTypes target,
  }) = CardEffectGrantShield;

  const factory CardEffects.grantCost({
    required int amount,
    required CardTargetTypes target,
  }) = CardEffectGrantCost;

  const factory CardEffects.stealCost({
    required int amount,
  }) = CardEffectStealCost;

  const factory CardEffects.stealShield({
    required int amount,
  }) = CardEffectStealShield;

  const factory CardEffects.applyBuff({
    required BuffTypes buff,
    required int stacks,
    required CardTargetTypes target,
  }) = CardEffectApplyBuff;

  const factory CardEffects.applyDebuff({
    required DebuffTypes debuff,
    required int stacks,
    required CardTargetTypes target,
  }) = CardEffectApplyDebuff;

  const factory CardEffects.removeBuff({
    required BuffTypes buff,
    required int stacks,
    required CardTargetTypes target,
  }) = CardEffectRemoveBuffs;

  const factory CardEffects.removeDebuff({
    required DebuffTypes debuff,
    required int stacks,
    required CardTargetTypes target,
  }) = CardEffectRemoveDebuffs;

  factory CardEffects.fromJson(Map<String, dynamic> json) =>
      _$CardEffectsFromJson(json);
}

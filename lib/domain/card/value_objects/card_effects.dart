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
  }) = _Damage;

  const factory CardEffects.draw({
    required int amount,
  }) = _Draw;

  const factory CardEffects.discard({required GameCard card}) = _Discard;

  const factory CardEffects.fetchCard({required GameCard card}) = _FetchCard;

  const factory CardEffects.heal({
    required int amount,
    required CardTargetTypes target,
  }) = _Heal;

  const factory CardEffects.grantShield({
    required int amount,
    required CardTargetTypes target,
  }) = _GrantShield;

  const factory CardEffects.grantCost({
    required int amount,
    required CardTargetTypes target,
  }) = _GrantCost;

  const factory CardEffects.stealCost({
    required int amount,
  }) = _StealCost;

  const factory CardEffects.stealShield({
    required int amount,
  }) = _StealShield;

  const factory CardEffects.applyBuff({
    required BuffTypes buff,
    required int stacks,
    required CardTargetTypes target,
  }) = _ApplyBuff;

  const factory CardEffects.applyDebuff({
    required DebuffTypes debuff,
    required int stacks,
    required CardTargetTypes target,
  }) = _ApplyDebuff;

  const factory CardEffects.removeBuff({
    required BuffTypes buff,
    required int stacks,
    required CardTargetTypes target,
  }) = _RemoveBuffs;

  const factory CardEffects.removeDebuff({
    required DebuffTypes debuff,
    required int stacks,
    required CardTargetTypes target,
  }) = _RemoveDebuffs;

  factory CardEffects.fromJson(Map<String, dynamic> json) =>
      _$CardEffectsFromJson(json);
}

import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'effect_conditions.g.dart';
part 'effect_conditions.freezed.dart';

@freezed
sealed class EffectConditions with _$EffectConditions {
  const factory EffectConditions.targetHasBuffCondition({
    required BuffTypes buff,
    required CardTargetTypes target,
  }) = _TargetHasBuffCondition;

  const factory EffectConditions.targetHasDebuffCondition({
    required DebuffTypes debuff,
    required CardTargetTypes target,
  }) = _TargetHasDebuffCondition;

  const factory EffectConditions.targetHpPercentageCondition({
    required CardTargetTypes target,
    required double percentage,
    required ComparisonOperator operator,
  }) = _TargetHpPercentageCondition;

  const factory EffectConditions.targetHpValueCondition({
    required CardTargetTypes target,
    required int value,
    required ComparisonOperator operator,
  }) = _TargetHpValueCondition;

  factory EffectConditions.fromJson(Map<String, dynamic> json) =>
      _$EffectConditionsFromJson(json);
}

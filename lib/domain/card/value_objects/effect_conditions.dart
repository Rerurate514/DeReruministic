import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'effect_conditions.g.dart';
part 'effect_conditions.freezed.dart';

@freezed
sealed class EffectConditions with _$EffectConditions {
  factory EffectConditions.fromJson(Map<String, dynamic> json) =>
      _$EffectConditionsFromJson(json);

  const factory EffectConditions.targetHasBuffCondition({
    required CardTargetTypes target,
    required BuffTypes buff,
  }) = EffectConditionTargetHasBuffCondition;

  const factory EffectConditions.targetHasDebuffCondition({
    required CardTargetTypes target,
    required DebuffTypes debuff,
  }) = EffectConditionTargetHasDebuffCondition;

  const factory EffectConditions.targetHpPercentageCondition({
    required CardTargetTypes target,
    required int percentage,
    required ComparisonOperator operator,
  }) = EffectConditionTargetHpPercentageCondition;

  const factory EffectConditions.targetHpValueCondition({
    required CardTargetTypes target,
    required int value,
    required ComparisonOperator operator,
  }) = EffectConditionTargetHpValueCondition;

  @override
  CardTargetTypes get target;
}

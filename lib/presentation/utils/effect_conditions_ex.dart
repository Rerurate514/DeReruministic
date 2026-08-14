import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/presentation/utils/buff_types_ex.dart';
import 'package:dereruministic/presentation/utils/card_target_types_ex.dart';
import 'package:dereruministic/presentation/utils/comparison_operator_ex.dart';
import 'package:dereruministic/presentation/utils/debuff_types_ex.dart';

extension EffectConditionsEx on EffectConditions {
  String text() {
    return switch (this) {
      EffectConditionTargetHasBuffCondition(:final target, :final buff) =>
        '${target.text()}が${buff.text()}状態の場合',
      EffectConditionTargetHasDebuffCondition(:final target, :final debuff) =>
        '${target.text()}が${debuff.text()}状態の場合',
      EffectConditionTargetHpPercentageCondition(
        :final target,
        :final percentage,
        :final operator,
      ) =>
        '${target.text()}のHPが$percentage%${operator.text()}の場合',
      EffectConditionTargetHpValueCondition(
        :final target,
        :final value,
        :final operator,
      ) =>
        '${target.text()}のHPが$value${operator.text()}の場合',
    };
  }
}

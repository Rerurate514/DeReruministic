import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/utils/buff_types_ex.dart';
import 'package:dereruministic/presentation/utils/card_target_types_ex.dart';
import 'package:dereruministic/presentation/utils/comparison_operator_ex.dart';
import 'package:dereruministic/presentation/utils/debuff_types_ex.dart';

extension EffectConditionsEx on EffectConditions {
  String text(AppLocalizations l10n) {
    return switch (this) {
      EffectConditionTargetHasBuffCondition(:final target, :final buff) =>
        l10n.effect_condition_target_has_buff(
          target.text(l10n),
          buff.text(),
        ),
      EffectConditionTargetHasDebuffCondition(:final target, :final debuff) =>
        l10n.effect_condition_target_has_debuff(
          target.text(l10n),
          debuff.text(),
        ),
      EffectConditionTargetHpPercentageCondition(
        :final target,
        :final percentage,
        :final operator,
      ) =>
        l10n.effect_condition_target_hp_percentage(
          target.text(l10n),
          percentage,
          operator.text(l10n),
        ),
      EffectConditionTargetHpValueCondition(
        :final target,
        :final value,
        :final operator,
      ) =>
        l10n.effect_condition_target_hp_value(
          target.text(l10n),
          value,
          operator.text(l10n),
        ),
    };
  }
}

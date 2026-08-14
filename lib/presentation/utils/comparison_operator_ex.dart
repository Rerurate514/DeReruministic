import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/l10n/app_localizations.dart';

extension ComparisonOperatorEx on ComparisonOperator {
  String text(AppLocalizations l10n) {
    return switch (this) {
      ComparisonOperator.equal => l10n.comparison_operator_equal,
      ComparisonOperator.greaterThan => l10n.comparison_operator_greater_than,
      ComparisonOperator.lessThan => l10n.comparison_operator_less_than,
      ComparisonOperator.notEqual => l10n.comparison_operator_not_equal,
      ComparisonOperator.greaterOrEqual =>
        l10n.comparison_operator_greater_or_equal,
      ComparisonOperator.lessOrEqual => l10n.comparison_operator_less_or_equal,
    };
  }
}

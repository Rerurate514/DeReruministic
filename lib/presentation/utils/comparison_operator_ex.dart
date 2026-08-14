import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';

extension ComparisonOperatorEx on ComparisonOperator {
  String text() {
    return switch (this) {
      ComparisonOperator.equal => 'と等しい',
      ComparisonOperator.greaterThan => 'より大きい',
      ComparisonOperator.lessThan => '未満',
      ComparisonOperator.notEqual => 'と等しくない',
      ComparisonOperator.greaterOrEqual => '以上',
      ComparisonOperator.lessOrEqual => '以下',
    };
  }
}

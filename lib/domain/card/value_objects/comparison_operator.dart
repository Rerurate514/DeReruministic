enum ComparisonOperator {
  equal,
  notEqual,
  greaterThan,
  greaterOrEqual,
  lessThan,
  lessOrEqual,
}

extension ComparisonOperatorEx on ComparisonOperator {
  bool evaluate(num target, num value) => switch (this) {
    ComparisonOperator.equal => target == value,
    ComparisonOperator.notEqual => target != value,
    ComparisonOperator.greaterThan => target > value,
    ComparisonOperator.greaterOrEqual => target >= value,
    ComparisonOperator.lessThan => target < value,
    ComparisonOperator.lessOrEqual => target <= value,
  };
}

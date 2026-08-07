enum DebuffTypes {
  atkDebuff,
  poison,
  vulnerable,
  costReduction,
  drawReduction,
}

extension DebuffTypesDamageModifier on DebuffTypes {
  bool get isOutgoingDamageModifier => switch (this) {
    DebuffTypes.atkDebuff => true,
    _ => false,
  };

  bool get isIncomingDamageModifier => switch (this) {
    DebuffTypes.vulnerable => true,
    _ => false,
  };
}

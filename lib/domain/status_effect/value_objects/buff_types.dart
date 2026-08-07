enum BuffTypes {
  atkBuff,
  regeneration,
  costRecovery,
  guardBoost,
  reflect,
  combo,
  drawBoost,
}

extension BuffTypesDamageModifier on BuffTypes {
  bool get isOutgoingDamageModifier => switch (this) {
    BuffTypes.atkBuff || BuffTypes.combo => true,
    _ => false,
  };

  bool get isIncomingDamageModifier => switch (this) {
    _ => false,
  };
}

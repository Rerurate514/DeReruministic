enum EventTrigger {
  onTurnStart,
  onDrawPhaseStart,
  onDrawPhaseEnd,
  onMainPhaseStart,
  onMainPhaseEnd,
  onTurnEnd,

  onCardDrawn,
  onCardPlayed,
  onCardDiscarded,
  onCardExhausted,
  onCardAddedToHand,
  onCardAddedToDeck,

  onBeforeAttack,
  onAfterAttack,
  onBeforeTakeDamage,
  onTakeDamage,
  onDealDamage,
  onShieldGained,
  onShieldBroken,
  onHeal,

  onStatusEffectApplied,
  onStatusEffectRemoved,

  onBattleStart,
  onBattleEnd,
}

enum BattlePhase {
  initialize,
  battleStart,
  turnStart,
  mainPhase,
  turnEnd,
  battleEnd;

  bool get isFinished => this == BattlePhase.battleEnd;
}

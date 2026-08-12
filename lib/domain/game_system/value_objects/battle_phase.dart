enum BattlePhase {
  initialize,
  battleStart,
  turnStart,
  mainPhase,
  turnEnd,
  battleEnd,
  selectDiscard
  ;

  bool get isFinished => this == BattlePhase.battleEnd;

  bool get requiresPlayerInput => this == BattlePhase.selectDiscard;
}

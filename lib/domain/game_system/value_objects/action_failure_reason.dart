enum ActionFailureReason {
  notEnoughCost, // コスト不足
  cardNotFound, // 指定されたカードが存在しない
  playerNotFound, // プレイヤーが存在しない
  invalidPhase, // 現在のフェーズでは実行不能
  invalidActionSequence, //GameStateのシーケンス番号とActionsのシーケンス番号が一致しない
}

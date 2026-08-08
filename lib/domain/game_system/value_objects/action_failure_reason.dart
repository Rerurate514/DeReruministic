enum ActionFailureReason {
  notEnoughCost, // コスト不足
  cardNotFound, // 指定されたカードが存在しない
  playerNotFound, // プレイヤーが存在しない
  invalidPhase, // 現在のフェーズでは実行不能
}

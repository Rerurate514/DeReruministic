enum ActionFailureReason {
  notEnoughCost, // コスト不足
  cardNotFound, // 指定されたカードが存在しない
  playerNotFound, // プレイヤーが存在しない
  invalidPhase, // 現在のフェーズでは実行不能
  invalidAction, // 処理の流れ上で不正なアクションが流れてきた時
  invalidActionSequence, //GameStateのシーケンス番号とActionsのシーケンス番号が一致しない
}

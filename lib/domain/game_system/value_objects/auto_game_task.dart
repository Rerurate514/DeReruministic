import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_game_task.freezed.dart';
part 'auto_game_task.g.dart';

@freezed
sealed class AutoGameTask with _$AutoGameTask {
  // 自動実行タスク
  // ゲーム開始パイプライン
  const factory AutoGameTask.gameStartDrawCards() =
      AutoGameTaskGameStartDrawCards;
  const factory AutoGameTask.advanceToTurnStart() =
      AutoGameTaskAdvanceToTurnStart;
  const factory AutoGameTask.calculateCost() = AutoGameTaskCalculateCost;
  const factory AutoGameTask.advanceToMainPhase() =
      AutoGameTaskAdvanceToMainPhase;

  // ターン終了パイプライン
  const factory AutoGameTask.turnEndPhaseChanged() =
      AutoGameTaskTurnEndPhaseChanged;
  const factory AutoGameTask.updateCardCounter() =
      AutoGameTaskUpdateCardCounter;
  // const factory AutoGameTask.resolveTimedCardEffects() =
  //     AutoGameTaskResolveTimedCardEffects;
  // const factory AutoGameTask.resolveTurnEndStatus() =
  //     AutoGameTaskResolveTurnEndStatus;
  // const factory AutoGameTask.processRottenCardExhaust() =
  //     AutoGameTaskProcessRottenCardExhaust;
  // const factory AutoGameTask.triggerOnTurnEndEvent() =
  //     AutoGameTaskTriggerOnTurnEndEvent;
  const factory AutoGameTask.defeatCheck() = AutoGameTaskDefeatCheck;

  // 手番交代
  const factory AutoGameTask.switchTurnOwner() = AutoGameTaskSwitchTurnOwner;

  // ターン開始フェーズ
  const factory AutoGameTask.removeShield() = AutoGameTaskRemoveShield;
  // const factory AutoGameTask.resolveRegen() = AutoGameTaskResolveRegen;
  // const factory AutoGameTask.resolvePoison() = AutoGameTaskResolvePoison;
  // (defeatCheck を再利用)
  // (calculateCost を再利用)
  // const factory AutoGameTask.applyGuardBoost() = AutoGameTaskApplyGuardBoost;
  // const factory AutoGameTask.resetCombo() = AutoGameTaskResetCombo;
  // const factory AutoGameTask.triggerOnTurnStartEvent() =
  //     AutoGameTaskTriggerOnTurnStartEvent;

  // ドローフェーズ
  const factory AutoGameTask.cardDraw() = AutoGameTaskCardDraw;
  const factory AutoGameTask.checkHandLimit() = AutoGameTaskCheckHandLimit;

  factory AutoGameTask.fromJson(Map<String, dynamic> json) =>
      _$AutoGameTaskFromJson(json);
}

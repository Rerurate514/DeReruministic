import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'game_task.freezed.dart';
part 'game_task.g.dart';

@freezed
sealed class GameTask with _$GameTask {
  const GameTask._();

  // 自動実行タスク
  // ゲーム開始パイプライン
  const factory GameTask.gameStartDrawCards() = GameTaskGameStartDrawCards;
  const factory GameTask.advanceToTurnStart() = GameTaskAdvanceToTurnStart;
  const factory GameTask.calculateCost() = GameTaskCalculateCost;
  const factory GameTask.advanceToMainPhase() = GameTaskAdvanceToMainPhase;

  // ターン終了パイプライン
  const factory GameTask.turnEndPhaseChanged() = GameTaskTurnEndPhaseChanged;
  const factory GameTask.updateCardCounter() = GameTaskUpdateCardCounter;
  // const factory GameTask.resolveTimedCardEffects() =
  //     GameTaskResolveTimedCardEffects;
  // const factory GameTask.resolveTurnEndStatus() =
  //     GameTaskResolveTurnEndStatus;
  // const factory GameTask.processRottenCardExhaust() =
  //     GameTaskProcessRottenCardExhaust;
  // const factory GameTask.triggerOnTurnEndEvent() =
  //     GameTaskTriggerOnTurnEndEvent;
  const factory GameTask.defeatCheck() = GameTaskDefeatCheck;

  // 手番交代
  const factory GameTask.switchTurnOwner() = GameTaskSwitchTurnOwner;

  // ターン開始フェーズ
  const factory GameTask.removeShield() = GameTaskRemoveShield;
  // const factory GameTask.resolveRegen() = GameTaskResolveRegen;
  // const factory GameTask.resolvePoison() = GameTaskResolvePoison;
  // (defeatCheck を再利用)
  // (calculateCost を再利用)
  // const factory GameTask.applyGuardBoost() = GameTaskApplyGuardBoost;
  // const factory GameTask.resetCombo() = GameTaskResetCombo;
  // const factory GameTask.triggerOnTurnStartEvent() =
  //     GameTaskTriggerOnTurnStartEvent;

  // ドローフェーズ
  const factory GameTask.cardDraw() = GameTaskCardDraw;
  const factory GameTask.checkHandLimit() = GameTaskCheckHandLimit;

  // ユーザー入力待ちタスク
  const factory GameTask.mainPhase({
    @PlayerIdConverter() required PlayerId activePlayerId,
  }) = GameTaskMainPhase;

  const factory GameTask.selectOverflowDiscard({
    @PlayerIdConverter() required PlayerId targetPlayerId,
    required int overflowCount,
  }) = GameTaskSelectOverflowDiscard;

  factory GameTask.fromJson(Map<String, dynamic> json) =>
      _$GameTaskFromJson(json);

  bool get isInteractive => switch (this) {
    GameTaskMainPhase() => true,
    GameTaskSelectOverflowDiscard() => true,
    _ => false,
  };
}

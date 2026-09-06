import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'game_task.freezed.dart';
part 'game_task.g.dart';

@freezed
sealed class GameTask with _$GameTask {
  const GameTask._();

  // --- 1. 自動実行タスク ---
  // ゲーム開始パイプライン (createGameStartPipeline)
  const factory GameTask.gameStartDrawCards() = GameTaskGameStartDrawCards;
  const factory GameTask.advanceToTurnStart() = GameTaskAdvanceToTurnStart;
  const factory GameTask.calculateCost() = GameTaskCalculateCost;
  const factory GameTask.advanceToMainPhase() = GameTaskAdvanceToMainPhase;

  // ターン終了パイプライン (createTurnEndPipeline)
  const factory GameTask.turnEndPhaseChanged() = GameTaskTurnEndPhaseChanged;
  const factory GameTask.updateCardCounter() = GameTaskUpdateCardCounter;
  const factory GameTask.defeatCheck() = GameTaskDefeatCheck;
  const factory GameTask.switchTurnOwner() = GameTaskSwitchTurnOwner;
  const factory GameTask.removeShield() = GameTaskRemoveShield;
  const factory GameTask.cardDraw() = GameTaskCardDraw;
  const factory GameTask.checkHandLimit() = GameTaskCheckHandLimit;

  // --- 2. ユーザー入力待ちタスク ---
  const factory GameTask.selectOverflowDiscard({
    @PlayerIdConverter() required PlayerId targetPlayerId,
    required int overflowCount,
  }) = GameTaskSelectOverflowDiscard;

  factory GameTask.fromJson(Map<String, dynamic> json) =>
      _$GameTaskFromJson(json);

  bool get isInteractive => switch (this) {
    GameTaskSelectOverflowDiscard() => true,
    _ => false,
  };
}

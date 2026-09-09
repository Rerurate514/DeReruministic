import 'package:dereruministic/domain/card/converter/game_card_instance_id_converter.dart';
import 'package:dereruministic/domain/card/value_objects/action_targets.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_states_trigger_type.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
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

  // カード効果
  const factory AutoGameTask.applyCardEffect({
    @PlayerIdConverter() required PlayerId playerId,
    required CardEffects effect,
    ActionTargets? target,
  }) = AutoGameTaskApplyCardEffect;

  const factory AutoGameTask.applyCardState({
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdConverter() required GameCardInstanceId instanceId,
    required CardStates cardState,
  }) = AutoGameTaskApplyCardState;

  const factory AutoGameTask.resolveEndPhaseCardStates({
    @PlayerIdConverter() required PlayerId playerId,
  }) = AutoGameTaskResolveEndPhaseCardStates;

  const factory AutoGameTask.resolveCardStatesTrigger({
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdConverter() required GameCardInstanceId instanceId,
    required CardStatesTriggerType triggerType,
  }) = AutoGameTaskResolveCardStatesTrigger;

  const factory AutoGameTask.consumePlayCost({
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdConverter() required GameCardInstanceId instanceId,
  }) = AutoGameTaskConsumePlayCost;

  const factory AutoGameTask.consumeCard({
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdConverter() required GameCardInstanceId instanceId,
  }) = AutoGameTaskConsumeCard;

  const factory AutoGameTask.moveCardZone({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
    required CardZone zoneFrom,
    required CardZone zoneTo,
  }) = AutoGameTaskMoveCardZone;

  const factory AutoGameTask.cleanupPlayCard({
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
  }) = AutoGameTaskCleanupPlayCard;

  factory AutoGameTask.fromJson(Map<String, dynamic> json) =>
      _$AutoGameTaskFromJson(json);
}

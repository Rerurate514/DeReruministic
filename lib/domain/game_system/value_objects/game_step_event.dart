import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_end_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/status_effect_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_step_event.freezed.dart';
part 'game_step_event.g.dart';

@freezed
sealed class GameStepEvent with _$GameStepEvent {
  factory GameStepEvent.fromJson(Map<String, dynamic> json) =>
      _$GameStepEventFromJson(json);

  // --- 単純な状態遷移マーカー系 ---
  const factory GameStepEvent.comboReset({
    required GamePhase phase,
  }) = GameStepEventComboReset;

  const factory GameStepEvent.deckShuffled({
    required GamePhase phase,
  }) = GameStepEventDeckShuffled;

  const factory GameStepEvent.overflowCheckTriggered({
    required PlayerId playerId,
    required int overflowCount,
  }) = GameStepEventOverflowCheckTriggered;

  const factory GameStepEvent.phaseChanged({
    required GamePhase phase,
  }) = GameStepEventPhaseChanged;

  const factory GameStepEvent.turnEndEffectsResolved({
    required GamePhase phase,
  }) = GameStepEventTurnEndEffectsResolved;

  // --- 数値変化系 ---
  const factory GameStepEvent.regenApplied({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventRegenApplied;

  const factory GameStepEvent.costCalculated({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventCostCalculated;

  const factory GameStepEvent.drawCalculated({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventDrawCalculated;

  const factory GameStepEvent.comboUpdated({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventComboUpdated;

  const factory GameStepEvent.damageDealt({
    required PlayerId targetPlayerId,
    required int hpDamage,
    required int shieldDamage,
  }) = GameStepEventDamageDealt;

  const factory GameStepEvent.reflectDamageApplied({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventReflectDamageApplied;

  const factory GameStepEvent.shieldGained({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventShieldGained;

  const factory GameStepEvent.shieldRemoved({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventShieldRemoved;

  const factory GameStepEvent.shieldCleared({
    required PlayerId targetPlayerId,
  }) = GameStepEventShieldCleared;

  const factory GameStepEvent.healed({
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventHealed;

  const factory GameStepEvent.handCardCountersUpdated({
    required PlayerId playerId,
  }) = GameStepEventHandCardCountersUpdated;

  // --- バフ・デバフ（状態変化）系 ---
  const factory GameStepEvent.buffApplied({
    required PlayerId targetPlayerId,
    required BuffTypes buff,
    required int stack,
    required int totalStack, // 付与後の合計スタック数
  }) = GameStepEventBuffApplied;

  const factory GameStepEvent.debuffApplied({
    required PlayerId targetPlayerId,
    required DebuffTypes debuff,
    required int stack,
    required int totalStack,
  }) = GameStepEventDebuffApplied;

  const factory GameStepEvent.buffRemoved({
    required PlayerId targetPlayerId,
    required BuffTypes buff,
  }) = GameStepEventBuffRemoved;

  const factory GameStepEvent.debuffRemoved({
    required PlayerId targetPlayerId,
    required DebuffTypes debuff,
  }) = GameStepEventDebuffRemoved;

  // --- ステータス効果（スタック）系 ---
  const factory GameStepEvent.statusEffectChanged({
    required PlayerId targetPlayerId,
    required StatusEffectType effectType,
    required int stackCount,
  }) = GameStepEventStatusEffectChanged;

  // --- カードアクション系 ---
  const factory GameStepEvent.cardPlayed({
    required PlayerId playerId,
    required GameCardInstanceId cardInstanceId,
    required CardDefinitionId cardDefId,
    PlayerId? targetPlayerId,
  }) = GameStepEventCardPlayed;

  const factory GameStepEvent.cardExhausted({
    required PlayerId playerId,
    required GameCardInstanceId cardInstanceId,
    PlayerId? targetPlayerId,
  }) = GameStepEventCardExhausted;

  // --- デッキ復元 ---
  const factory GameStepEvent.deckRestored({
    required PlayerId playerId,
    required int count,
  }) = GameStepEventDeckRestored;

  // --- カードゾーン移動系 ---
  const factory GameStepEvent.cardsDrawn({
    required PlayerId playerId,
    required List<GameCardInstanceId> cardInstanceIds,
    required CardZone zoneFrom,
    required CardZone zoneTo,
  }) = GameStepEventCardsDrawn;

  const factory GameStepEvent.cardMovedZone({
    required PlayerId playerId,
    required List<GameCardInstanceId> cardInstanceIds,
    required CardZone zoneFrom,
    required CardZone zoneTo,
  }) = GameStepEventCardMovedZone;

  // --- ターン管理系 ---
  const factory GameStepEvent.turnOwnerSwitched({
    required PlayerId newTurnPlayerId,
  }) = GameStepEventTurnOwnerSwitched;

  // --- ゲーム開始・終了 ---
  const factory GameStepEvent.gameStarted({
    required PlayerId firstTurnPlayerId,
  }) = GameStepEventGameStarted;

  const factory GameStepEvent.gameEnded({
    required GameEndResult endResult,
    required PlayerId? winnerPlayerId,
    required PlayerId? loserPlayerId,
    required DefeatReason reason,
  }) = GameStepEventGameEnded;
}

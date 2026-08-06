import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_end_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/status_effect_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_step_event.freezed.dart';
part 'game_step_event.g.dart';

@freezed
sealed class GameStepEvent with _$GameStepEvent {
  factory GameStepEvent.fromJson(Map<String, dynamic> json) =>
      _$GameStepEventFromJson(json);
  const factory GameStepEvent.transition({
    required GameStepType type,
    required GamePhase phase,
  }) = GameStepEventTransition;

  const factory GameStepEvent.valueChanged({
    required GameStepType type,
    required PlayerId targetPlayerId,
    required int amount,
  }) = GameStepEventValueChanged;

  const factory GameStepEvent.statusEffectChanged({
    required GameStepType type,
    required PlayerId targetPlayerId,
    required StatusEffectType effectType,
    required int stackCount,
  }) = GameStepBuffChanged;

  const factory GameStepEvent.cardsAffected({
    required GameStepType type,
    required PlayerId targetPlayerId,
    required List<GameCardInstanceId> cardInstanceIds,
  }) = GameStepEventCardsAffected;

  const factory GameStepEvent.cardAction({
    required GameStepType type,
    required PlayerId playerId,
    required GameCardInstanceId cardInstanceId,
    PlayerId? targetPlayerId,
  }) = GameStepEventCardAction;

  const factory GameStepEvent.deckRestored({
    required GameStepType type,
    required PlayerId playerId,
    required int count,
  }) = GameStepEventDeckRestored;

  const factory GameStepEvent.cardZoneMoved({
    required GameStepType type,
    required PlayerId playerId,
    required List<GameCardInstanceId> cardInstanceIds,
    required CardZone typeFrom,
    required CardZone typeTo,
  }) = GameStepEventCardZoneMoved;

  const factory GameStepEvent.gameStarted({
    required GameStepType type,
    required PlayerId firstTurnPlayerId,
  }) = GameStepEventGameStarted;

  const factory GameStepEvent.gameEnded({
    required GameStepType type,
    required GameEndResult endResult,
    required PlayerId? winnerPlayerId,
    required PlayerId? loserPlayerId,
    required DefeatReason reason,
  }) = GameStepEventGameEnded;

  @override
  GameStepType get type;
}

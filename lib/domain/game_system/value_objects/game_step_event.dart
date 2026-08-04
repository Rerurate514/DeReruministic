import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_types.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/status_effect_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_step_event.freezed.dart';
part 'game_step_event.g.dart';

@freezed
sealed class GameStepEvent with _$GameStepEvent {
  const factory GameStepEvent.transition({
    required GameStepType type,
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

  const factory GameStepEvent.gameEnded({
    required PlayerId? winnerPlayerId,
    required String reason,
  }) = GameStepEventGameEnded;

  factory GameStepEvent.fromJson(Map<String, dynamic> json) =>
      _$GameStepEventFromJson(json);
}

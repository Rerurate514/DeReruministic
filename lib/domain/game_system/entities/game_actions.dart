import 'package:dereruministic/domain/card/converter/game_card_instance_id_converter.dart';
import 'package:dereruministic/domain/card/value_objects/action_targets.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/game_system/converter/game_actions_id_converter.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/player/converter/player_id_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_actions.freezed.dart';
part 'game_actions.g.dart';

@freezed
sealed class GameActions with _$GameActions {
  factory GameActions.fromJson(Map<String, dynamic> json) =>
      _$GameActionsFromJson(json);

  const GameActions._();

  const factory GameActions.gameStart({
    @GameActionsIdConverter() required GameActionsId id,
    required int actionSequenceNumber,
    @PlayerIdConverter() required PlayerId playerAId,
    @PlayerIdConverter() required PlayerId playerBId,
    required DeckRecipe playerADeckRecipe,
    required DeckRecipe playerBDeckRecipe,
    required int seed,
  }) = GameActionGameStart;

  const factory GameActions.playCard({
    @GameActionsIdConverter() required GameActionsId id,
    required int actionSequenceNumber,
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdConverter() required GameCardInstanceId cardInstanceId,
    ActionTargets? target,
  }) = GameActionPlayCard;

  const factory GameActions.discardCard({
    @GameActionsIdConverter() required GameActionsId id,
    required int actionSequenceNumber,
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdConverter() required GameCardInstanceId cardInstanceId,
  }) = GameActionDiscardCard;

  const factory GameActions.selectOverflowDiscards({
    @GameActionsIdConverter() required GameActionsId id,
    required int actionSequenceNumber,
    @PlayerIdConverter() required PlayerId playerId,
    @GameCardInstanceIdListConverter()
    required List<GameCardInstanceId> selectedCardInstanceIds,
  }) = GameActionSelectOverflowDiscards;

  const factory GameActions.turnEnd({
    @GameActionsIdConverter() required GameActionsId id,
    required int actionSequenceNumber,
    @PlayerIdConverter() required PlayerId playerId,
  }) = GameActionTurnEnd;

  const factory GameActions.surrender({
    @GameActionsIdConverter() required GameActionsId id,
    required int actionSequenceNumber,
    @PlayerIdConverter() required PlayerId playerId,
  }) = GameActionSurrender;

  @override
  int get actionSequenceNumber;
}

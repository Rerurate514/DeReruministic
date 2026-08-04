import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/turn_owner.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_actions.freezed.dart';
part 'game_actions.g.dart';

@freezed
sealed class GameActions with _$GameActions {
  const factory GameActions.gameStart({
    required GameActionsId id,
    required PlayerId playerId,
    required PlayerId enemyId,
    required int seed,
    required TurnOwner firstTurn,
  }) = GameActionGameStart;

  const factory GameActions.playCard({
    required GameActionsId id,
    required PlayerId playerId,
    required GameCardInstanceId cardInstanceId,
    PlayerId? targetPlayerId,
  }) = GameActionPlayCard;

  const factory GameActions.discardCard({
    required GameActionsId id,
    required PlayerId playerId,
    required GameCardInstanceId cardInstanceId,
  }) = GameActionDiscardCard;

  const factory GameActions.selectOverflowDiscards({
    required GameActionsId id,
    required PlayerId playerId,
    required List<GameCardInstanceId> selectedCardInstanceIds,
  }) = GameActionSelectOverflowDiscards;

  const factory GameActions.turnEnd({
    required GameActionsId id,
    required PlayerId playerId,
  }) = GameActionTurnEnd;

  const factory GameActions.surrender({
    required GameActionsId id,
    required PlayerId playerId,
  }) = GameActionSurrender;

  factory GameActions.fromJson(Map<String, dynamic> json) =>
      _$GameActionsFromJson(json);
}

import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_actions.freezed.dart';
part 'game_actions.g.dart';

@freezed
sealed class GameActions with _$GameActions {
  const factory GameActions.gameStart({
    required GameActionsId id,
    required PlayerId playerId,
    required int seed,
  }) = _GameActionGameStart;

  const factory GameActions.playCard({
    required GameActionsId id,
    required PlayerId playerId,
    required GameCard card,
    PlayerId? targetPlayerId,
  }) = _GameActionPlayCard;

  const factory GameActions.discardCard({
    required GameActionsId id,
    required PlayerId playerId,
    required GameCard card,
  }) = _GameActionDiscardCard;

  const factory GameActions.selectOverflowDiscards({
    required GameActionsId id,
    required PlayerId playerId,
    required List<GameCard> selectedCards,
  }) = _GameActionSelectOverflowDiscards;

  const factory GameActions.turnEnd({
    required GameActionsId id,
    required PlayerId playerId,
  }) = _GameActionTurnEnd;

  const factory GameActions.surrender({
    required GameActionsId id,
    required PlayerId playerId,
  }) = _GameActionSurrender;

  factory GameActions.fromJson(Map<String, dynamic> json) =>
      _$GameActionsFromJson(json);
}

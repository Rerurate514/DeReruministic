import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    required int hp,
    required int maxHp,
    required int shield,
    required int currentCost,
    required List<GameCard> deck,
    required List<GameCard> hand,
    required List<GameCard> graveyard,
    required List<GameCard> exhausted,
    required List<BuffState> buffs,
    required List<DebuffState> debuffs,
    required int cardsPlayedThisTurn,
    required int maxHandSize,
    required int drawCount,
  }) = _PlayerState;

  factory PlayerState.create({required List<GameCard> deck}) {
    return PlayerState(
      hp: PlayerConstants.defaultInitialHp,
      maxHp: PlayerConstants.defaultMaxHp,
      shield: 0,
      currentCost: PlayerConstants.defaultInitialCost,
      deck: deck,
      hand: [],
      graveyard: [],
      exhausted: [],
      buffs: [],
      debuffs: [],
      cardsPlayedThisTurn: 0,
      maxHandSize: PlayerConstants.defaultMaxHandSize,
      drawCount: PlayerConstants.defaultDrawCount,
    );
  }

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}

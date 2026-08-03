import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    required int hp,
    required int shield,
    required int currentCost,
    required List<GameCard> hand,
    required List<GameCard> deck,
    required List<GameCard> graveyard,
    required List<BuffState> buffs,
    required List<DebuffState> debuffs,
    required int cardsPlayedThisTurn,
    required int maxHandSize,
  }) = _PlayerState;

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}

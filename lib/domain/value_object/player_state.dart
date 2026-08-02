import 'package:dereruministic/domain/entities/game_card.dart';
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
    // required List<BuffDebuff> buffs,
    required List<String> buffs,
    required int cardsPlayedThisTurn,
    required int maxHandSize,
  }) = _PlayerState;

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}

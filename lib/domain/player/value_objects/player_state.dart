import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    required PlayerId id,
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
    required int pendingRecoilCost,
  }) = _PlayerState;

  factory PlayerState.create({
    required PlayerId id,
    required List<GameCard> deck,
  }) {
    return PlayerState(
      id: id,
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
      pendingRecoilCost: 0,
    );
  }

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}

extension PlayerStateEx on PlayerState {
  PlayerState updateCost(int amount) {
    return copyWith(currentCost: currentCost + amount);
  }
}

import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_player_ui_state.freezed.dart';

@freezed
sealed class MyPlayerUiState with _$MyPlayerUiState {
  const factory MyPlayerUiState({
    required PlayerId id,
    required String name,
    required int hp,
    required int maxHp,
    required int cost,
    required int maxCost,
    required int shield,
    required List<GameCard> hand,
    required List<GameCard> deck,
    required List<GameCard> graveyard,
    required List<GameCard> exhausted,
    required bool isTurn,
    required List<BuffState> buffs,
    required List<DebuffState> debuffs,
  }) = _MyPlayerUiState;

  factory MyPlayerUiState.create({
    required Player player,
    required PlayerState playerState,
    required bool isTurn,
  }) {
    return MyPlayerUiState(
      id: player.id,
      name: player.name,
      hp: playerState.hp,
      maxHp: playerState.maxHp,
      cost: playerState.currentCost,
      maxCost: playerState.maxCost,
      shield: playerState.shield,
      hand: playerState.hand,
      deck: playerState.deck,
      graveyard: playerState.graveyard,
      exhausted: playerState.exhausted,
      isTurn: isTurn,
      buffs: playerState.buffs,
      debuffs: playerState.debuffs,
    );
  }
}

extension MyPlayerUiStateEx on MyPlayerUiState {
  double get hpRatio => maxHp > 0 ? hp / maxHp : 0.0;
}

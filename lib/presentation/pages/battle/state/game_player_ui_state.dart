import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_player_ui_state.freezed.dart';

@freezed
sealed class GamePlayerUiState with _$GamePlayerUiState {
  const factory GamePlayerUiState({
    required PlayerId id,
    required String name,
    required int hp,
    required int maxHp,
    required int shield,
    required int handCount,
  }) = _GamePlayerUiState;
}

extension GamePlayerUiStateEx on GamePlayerUiState {
  double get hpRatio => maxHp > 0 ? hp / maxHp : 0.0;
}

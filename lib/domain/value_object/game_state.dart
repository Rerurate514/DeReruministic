import 'package:dereruministic/domain/constants/game_phase.dart';
import 'package:dereruministic/domain/value_object/enemy_state.dart';
import 'package:dereruministic/domain/value_object/player_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
sealed class GameState with _$GameState {
  const factory GameState({
    required PlayerState player,
    required EnemyState enemy,
    required GamePhase phase,
    required int turnCount,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

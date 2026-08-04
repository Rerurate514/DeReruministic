import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/turn_owner.dart';
import 'package:dereruministic/domain/player/value_objects/enemy_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
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

extension GameStateEx on GameState {
  PlayerId get currentTurnPlayerId {
    switch (phase.owner) {
      case TurnOwner.player:
        return player.id;
      case TurnOwner.enemy:
        return enemy.id;
    }
  }
}

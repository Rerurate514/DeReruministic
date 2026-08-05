import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
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

  PlayerId get shieldClearTargetId {
    switch (phase.owner) {
      case TurnOwner.player:
        return enemy.id;
      case TurnOwner.enemy:
        return player.id;
    }
  }

  GameState clearShield(PlayerId targetId) {
    if (player.id == targetId) {
      return copyWith(player: player.copyWith(shield: 0));
    }
    if (enemy.id == targetId) {
      return copyWith(enemy: enemy.copyWith(shield: 0));
    }
    return this;
  }

  GameState switchTurnOwner() {
    final nextOwner = phase.owner == TurnOwner.player
        ? TurnOwner.enemy
        : TurnOwner.player;

    return copyWith(
      phase: phase.copyWith(
        owner: nextOwner,
      ),
    );
  }

  GameState nextTurn() {
    if (phase.battlePhase != BattlePhase.turnEnd) return this;

    final nextOwner = phase.owner == TurnOwner.player
        ? TurnOwner.enemy
        : TurnOwner.player;

    return copyWith(
      phase: phase.copyWith(
        owner: nextOwner,
        battlePhase: BattlePhase.turnStart,
      ),
    );
  }
}

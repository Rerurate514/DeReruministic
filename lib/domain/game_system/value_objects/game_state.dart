import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/player/converter/player_map_converter.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
sealed class GameState with _$GameState {
  const factory GameState({
    @PlayerMapConverter() required Map<PlayerId, PlayerState> players,
    required int seed,
    required GamePhase phase,
    required int turnCount,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

extension GameStateEx on GameState {
  PlayerState get currentTurnOwner => players[phase.turnOwner]!;

  GameState clearShield(PlayerId targetId) {
    final targetPlayer = players[targetId];
    if (targetPlayer == null) return this;

    return copyWith(
      players: {
        ...players,
        targetId: targetPlayer.copyWith(shield: 0),
      },
    );
  }

  GameState nextTurn() {
    final nextOwner = players.keys.firstWhere(
      (id) => id != phase.turnOwner,
    );

    return copyWith(
      turnCount: turnCount + 1,
      phase: phase.copyWith(
        battlePhase: BattlePhase.turnStart,
        turnOwner: nextOwner,
      ),
    );
  }
}

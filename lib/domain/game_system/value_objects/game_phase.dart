import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/turn_owner.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_phase.freezed.dart';
part 'game_phase.g.dart';

@freezed
sealed class GamePhase with _$GamePhase {
  const factory GamePhase({
    required BattlePhase battlePhase,
    required TurnOwner owner,
  }) = _GamePhase;

  factory GamePhase.init() {
    return const GamePhase(
      battlePhase: BattlePhase.battleStart,
      owner: TurnOwner.player,
    );
  }

  factory GamePhase.fromJson(Map<String, dynamic> json) =>
      _$GamePhaseFromJson(json);
}

import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_phase.freezed.dart';
part 'game_phase.g.dart';

@freezed
sealed class GamePhase with _$GamePhase {
  const factory GamePhase({
    required BattlePhase battlePhase,
    required PlayerId turnOwner,
    BattlePhase? interruptedPhase,
  }) = _GamePhase;

  factory GamePhase.init(PlayerId firstTurnOwner) {
    return GamePhase(
      battlePhase: BattlePhase.initialize,
      turnOwner: firstTurnOwner,
    );
  }

  factory GamePhase.fromJson(Map<String, dynamic> json) =>
      _$GamePhaseFromJson(json);
}

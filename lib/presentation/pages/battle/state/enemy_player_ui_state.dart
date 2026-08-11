import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'enemy_player_ui_state.freezed.dart';

@freezed
sealed class EnemyPlayerUiState with _$EnemyPlayerUiState {
  const factory EnemyPlayerUiState({
    required PlayerId id,
    required String name,
    required int hp,
    required int maxHp,
    required int cost,
    required int maxCost,
    required int shield,
    required int handCount,
    required int deckCount,
    required int graveyardCount,
    required int exhaustedCount,
    required bool isTurn,
    required List<BuffState> buffs,
    required List<DebuffState> debuffs,
  }) = _EnemyPlayerUiState;
}

extension EnemyPlayerUiStateEx on EnemyPlayerUiState {
  double get hpRatio => maxHp > 0 ? hp / maxHp : 0.0;
}

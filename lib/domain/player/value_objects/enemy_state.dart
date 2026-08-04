import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'enemy_state.freezed.dart';
part 'enemy_state.g.dart';

@freezed
sealed class EnemyState with _$EnemyState {
  const factory EnemyState({
    required int hp,
    required int maxHp,
    required int shield,
    required int handCount,
    required int deckCount,
    required List<GameCard> graveyard,
    required List<BuffState> buffs,
    required List<DebuffState> debuffs,
  }) = _EnemyState;

  factory EnemyState.create({required Player enemy}) {
    return EnemyState(
      hp: PlayerConstants.defaultInitialHp,
      maxHp: PlayerConstants.defaultMaxHp,
      shield: 0,
      handCount: 0,
      deckCount: enemy.deckRecipe.length,
      graveyard: [],
      buffs: [],
      debuffs: [],
    );
  }

  factory EnemyState.fromJson(Map<String, dynamic> json) =>
      _$EnemyStateFromJson(json);
}

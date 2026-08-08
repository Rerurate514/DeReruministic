import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';

enum CardTargetTypes {
  self,
  enemy,
}

extension CardTargetTypesEx on CardTargetTypes {
  PlayerState getTargetPlayer(
    GameState state,
    PlayerId sourcePlayerId,
  ) {
    return state.players[getTargetPlayerId(state, sourcePlayerId)]!;
  }

  PlayerId getTargetPlayerId(
    GameState state,
    PlayerId sourcePlayerId,
  ) {
    return switch (this) {
      CardTargetTypes.self => sourcePlayerId,
      CardTargetTypes.enemy =>
        state.players.values
            .firstWhere(
              (p) => p.id != sourcePlayerId,
            )
            .id,
    };
  }
}

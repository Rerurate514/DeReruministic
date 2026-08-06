import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';

abstract interface class DefeatRule {
  List<DefeatResult> evaluate(GameState state);
}

class HpZeroDefeatRule implements DefeatRule {
  @override
  List<DefeatResult> evaluate(GameState state) {
    return state.players.values
        .where((player) => player.hp <= 0)
        .map(
          (player) => DefeatResult(
            reason: DefeatReason.hpZero,
            loserPlayerId: player.id,
          ),
        )
        .toList();
  }
}

class DeckOutDefeatRule implements DefeatRule {
  @override
  List<DefeatResult> evaluate(GameState state) {
    return state.players.values
        .where((player) => player.deck.isEmpty && player.graveyard.isEmpty)
        .map(
          (player) => DefeatResult(
            reason: DefeatReason.deckOut,
            loserPlayerId: player.id,
          ),
        )
        .toList();
  }
}

import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_draw_service.g.dart';

@riverpod
CardDrawService cardDrawService(Ref ref) {
  return CardDrawService();
}

class CardDrawService {
  GameState execute(
    GameState state,
    PlayerId targetPlayerId,
    int amount,
  ) {
    final currentPlayer = state.players[targetPlayerId];
    if (currentPlayer == null || amount <= 0) return state;

    final drawCount = amount > currentPlayer.deck.length
        ? currentPlayer.deck.length
        : amount;

    if (drawCount == 0) return state;

    final drawnCards = currentPlayer.deck.take(drawCount).toList();
    final remainingDeck = currentPlayer.deck.skip(drawCount).toList();

    final updatedPlayer = currentPlayer.copyWith(
      deck: remainingDeck,
      hand: [...currentPlayer.hand, ...drawnCards],
    );

    return state.copyWith(
      players: {...state.players, targetPlayerId: updatedPlayer},
    );
  }
}

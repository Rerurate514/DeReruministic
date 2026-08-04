import 'dart:math';

import 'package:dereruministic/domain/card/constants/card_constants.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'draw_initial_hand_service.g.dart';

@riverpod
DrawInitialHandService drawInitialHandService(Ref ref) {
  return DrawInitialHandService();
}

class DrawInitialHandService {
  PlayerState execute(PlayerState playerState) {
    final drawCount = min(
      CardConstants.defaultIntialHandCount,
      playerState.deck.length,
    );

    final hand = playerState.deck.sublist(0, drawCount);
    final newDeck = playerState.deck.sublist(drawCount);

    return playerState.copyWith(hand: hand, deck: newDeck);
  }
}

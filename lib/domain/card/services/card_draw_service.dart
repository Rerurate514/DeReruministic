import 'dart:math';

import 'package:dereruministic/domain/card/services/deck_restoration_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_draw_service.g.dart';

@riverpod
CardDrawService cardDrawService(Ref ref) {
  return CardDrawService(
    deckRestorationService: ref.read(deckRestorationServiceProvider),
  );
}

class CardDrawService {
  const CardDrawService({
    required this.deckRestorationService,
  });

  final DeckRestorationService deckRestorationService;

  ApplyActionResult execute(
    GameState state,
    PlayerId targetPlayerId,
    int amount,
  ) {
    final currentPlayer = state.players[targetPlayerId];
    if (currentPlayer == null || amount <= 0) {
      return ApplyActionResult.noSteps(state: state);
    }

    final drawCount = amount > currentPlayer.deck.length
        ? currentPlayer.deck.length
        : amount;

    if (drawCount == 0) {
      return ApplyActionResult.noSteps(state: state);
    }

    final drawnCards = currentPlayer.deck.take(drawCount).toList();
    final remainingDeck = currentPlayer.deck.skip(drawCount).toList();

    final updatedPlayer = currentPlayer.copyWith(
      deck: remainingDeck,
      hand: [...currentPlayer.hand, ...drawnCards],
    );

    final drawStep = GameStepEvent.cardsDrawn(
      playerId: targetPlayerId,
      cardInstanceIds: drawnCards.map((card) => card.instanceId).toList(),
      zoneFrom: CardZone.deck,
      zoneTo: CardZone.hand,
    );

    final newState = state.copyWith(
      players: {...state.players, targetPlayerId: updatedPlayer},
    );

    final cardMoveStep = GameStepEvent.cardMovedZone(
      playerId: targetPlayerId,
      cardInstanceIds: drawnCards.map((card) => card.instanceId).toList(),
      zoneFrom: CardZone.deck,
      zoneTo: CardZone.hand,
    );

    if (remainingDeck.isNotEmpty) {
      return ApplyActionResult(
        state: newState,
        steps: [
          drawStep,
          cardMoveStep,
        ],
      );
    }

    final result = deckRestorationService.execute(
      newState,
      targetPlayerId,
      Random(state.seed),
    );

    return ApplyActionResult(
      state: result.state,
      steps: [drawStep, cardMoveStep, ...result.steps],
    );
  }
}

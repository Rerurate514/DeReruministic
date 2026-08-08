import 'dart:math';

import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_restoration_service.g.dart';

@riverpod
DeckRestorationService deckRestorationService(Ref ref) {
  return DeckRestorationService();
}

class DeckRestorationService {
  ApplyActionResult execute(
    GameState state,
    PlayerId targetPlayerId,
    Random random,
  ) {
    final currentPlayerState = state.players[targetPlayerId];
    if (currentPlayerState == null) {
      return ApplyActionResult.noSteps(state: state);
    }

    if (currentPlayerState.deck.isNotEmpty) {
      return ApplyActionResult.noSteps(state: state);
    }

    final restoredCards = List<GameCard>.from(currentPlayerState.graveyard)
      ..shuffle(random);

    final newPlayerState = currentPlayerState.copyWith(
      deck: restoredCards,
      graveyard: [],
    );

    final newState = state.copyWith(
      players: {...state.players, targetPlayerId: newPlayerState},
    );

    final moveStep = GameStepEvent.cardMovedZone(
      playerId: targetPlayerId,
      cardInstanceIds: restoredCards.map((card) => card.instanceId).toList(),
      zoneFrom: CardZone.graveyard,
      zoneTo: CardZone.deck,
    );

    final restoredStep = GameStepEvent.deckRestored(
      playerId: targetPlayerId,
      count: restoredCards.length,
    );

    return ApplyActionResult.success(
      state: newState,
      steps: [moveStep, restoredStep],
    );
  }
}

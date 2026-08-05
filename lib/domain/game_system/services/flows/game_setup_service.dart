import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/create_deck_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_service.g.dart';

@riverpod
GameSetupService gameSetupService(Ref ref) {
  final createDeckService = ref.read(createDeckServiceProvider);
  return GameSetupService(createDeckService: createDeckService);
}

class GameSetupService {
  const GameSetupService({required this.createDeckService});

  final CreateDeckService createDeckService;

  GameState execute({
    required Player playerA,
    required Player playerB,
    required List<CardDefinition> cardDefs,
    required int seed,
    PlayerId? firstTurn,
  }) {
    final random = Random(seed);

    final playerADeck = createDeckService.execute(
      cardDefs,
      playerA.deckRecipe,
      random,
    );

    final playerAState = PlayerState.create(
      id: playerA.id,
      deck: playerADeck,
    );

    final playerBDeck = createDeckService.execute(
      cardDefs,
      playerA.deckRecipe,
      random,
    );

    final playerBState = PlayerState.create(
      id: playerB.id,
      deck: playerBDeck,
    );

    final isPlayerFirst = firstTurn != null
        ? firstTurn == playerA.id
        : random.nextBool();

    final initialTurnOwner = isPlayerFirst ? playerA.id : playerB.id;

    return GameState(
      players: {
        playerA.id: playerAState,
        playerB.id: playerBState,
      },
      seed: seed,
      phase: GamePhase.init(initialTurnOwner),
      turnCount: 0,
    );
  }
}

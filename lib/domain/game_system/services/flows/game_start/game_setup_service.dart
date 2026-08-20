import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/create_deck_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
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

  ApplyActionResult execute({
    required PlayerId playerAId,
    required PlayerId playerBId,
    required List<CardDefinitionId> playerADeckRecipe,
    required List<CardDefinitionId> playerBDeckRecipe,
    required List<CardDefinition> cardDefs,
    required int seed,
    PlayerId? firstTurn,
  }) {
    final random = Random(seed);

    final playerADeck = createDeckService.execute(
      cardDefs,
      playerADeckRecipe,
      random,
    );

    final playerAState = PlayerState.create(
      id: playerAId,
      deck: playerADeck,
    );

    final playerBDeck = createDeckService.execute(
      cardDefs,
      playerBDeckRecipe,
      random,
    );

    final playerBState = PlayerState.create(
      id: playerBId,
      deck: playerBDeck,
    );

    final initialTurnOwner = FirstTurnResolver.resolve(
      playerAId: playerAId,
      playerBId: playerBId,
      random: random,
    );

    final newState = GameState(
      players: {
        playerAId: playerAState,
        playerBId: playerBState,
      },
      phase: GamePhase(battlePhase: .battleStart, turnOwner: initialTurnOwner),
      turnCount: 1,
      initialTurnOwner: initialTurnOwner,
      metadata: SystemMetadata(seed: seed, actionSequenceNumber: 0),
    );

    final turnStartStep = GameStepEvent.gameStarted(
      firstTurnPlayerId: initialTurnOwner,
    );

    return ApplyActionResult.success(state: newState, steps: [turnStartStep]);
  }
}

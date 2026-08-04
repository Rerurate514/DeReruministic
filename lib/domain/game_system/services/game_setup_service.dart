import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/create_deck_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/turn_owner.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/enemy_state.dart';
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
    required Player player,
    required Player enemy,
    required List<CardDefinition> cardDefs,
    int? seed,
    TurnOwner? firstTurn,
  }) {
    final random = Random(seed);

    final playerDeck = createDeckService.execute(
      cardDefs,
      player.deckRecipe,
      random,
    );

    final playerState = PlayerState.create(
      id: player.id,
      deck: playerDeck,
    );

    final enemyState = EnemyState.create(enemy: enemy);

    final isPlayerFirst = firstTurn != null
        ? firstTurn == TurnOwner.player
        : random.nextBool();

    final initialTurnOwner = isPlayerFirst ? TurnOwner.player : TurnOwner.enemy;

    return GameState(
      player: playerState,
      enemy: enemyState,
      phase: GamePhase.init(initialTurnOwner),
      turnCount: 0,
    );
  }
}

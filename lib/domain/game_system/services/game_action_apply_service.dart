import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_action_apply_service.g.dart';

@riverpod
GameActionApplyService gameActionApplyService(Ref ref) {
  return GameActionApplyService(
    gameSetupService: ref.read(gameSetupServiceProvider),
  );
}

class GameActionApplyService {
  const GameActionApplyService({required this.gameSetupService});

  final GameSetupService gameSetupService;

  GameState applyGameStart(
    GameActions action,
    Player player,
    Player enemy,
    List<CardDefinition> cardDefs,
  ) {
    final seed = (action as GameActionGameStart).seed;
    return gameSetupService.execute(
      player: player,
      enemy: enemy,
      cardDefs: cardDefs,
      seed: seed,
    );
  }
}

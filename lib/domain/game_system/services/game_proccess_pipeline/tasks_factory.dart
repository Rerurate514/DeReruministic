import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/value_objects/action_targets.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

class TasksFactory {
  static QueueList<GameTask> get gameStart => QueueList.from([
    const .auto(.gameStartDrawCards()),
    const .auto(.advanceToTurnStart()),
    const .auto(.calculateCost()),
    const .auto(.advanceToMainPhase()),
    const .interactive(
      .mainPhase(),
    ),
  ]);

  static QueueList<GameTask> get turnEndTasks => QueueList.from([
    const .auto(.turnEndPhaseChanged()),
    const .auto(.switchTurnOwner()),
    const .auto(.cardDraw()),
    const .auto(.checkHandLimit()),
    const .auto(.advanceToMainPhase()),
    const .interactive(
      .mainPhase(),
    ),
  ]);

  static QueueList<GameTask> applyPlayCardTasks({
    required PlayerId cardUsedPlayerId,
    required GameCardInstanceId cardInstanceId,
    required Iterable<CardEffects> validEffects,
    required Iterable<CardStates> states,
    ActionTargets? target,
  }) => QueueList.from([
    .auto(
      .consumeCard(
        playerId: cardUsedPlayerId,
        instanceId: cardInstanceId,
      ),
    ),
    .auto(
      .consumePlayCost(
        playerId: cardUsedPlayerId,
        instanceId: cardInstanceId,
      ),
    ),
    ...validEffects.map(
      (effect) => .auto(
        .applyCardEffect(
          playerId: cardUsedPlayerId,
          effect: effect,
          target: target,
        ),
      ),
    ),
    ...states.map(
      (cardState) => .auto(
        .applyCardState(
          playerId: cardUsedPlayerId,
          cardInstanceId: cardInstanceId,
          cardState: cardState,
        ),
      ),
    ),
    .auto(
      .cleanupPlayCard(
        playerId: cardUsedPlayerId,
        cardInstanceId: cardInstanceId,
      ),
    ),
  ]);
}

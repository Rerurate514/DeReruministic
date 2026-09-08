import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/value_objects/auto_game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/game_system/value_objects/interactive_game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

class TasksFactory {
  static QueueList<GameTask> gameStart({required PlayerId activePlayerId}) =>
      QueueList.from([
        const GameTask.auto(AutoGameTask.gameStartDrawCards()),
        const GameTask.auto(AutoGameTask.advanceToTurnStart()),
        const GameTask.auto(AutoGameTask.calculateCost()),
        const GameTask.auto(AutoGameTask.advanceToMainPhase()),
        GameTask.interactive(
          InteractiveGameTask.mainPhase(activePlayerId: activePlayerId),
        ),
      ]);

  static QueueList<GameTask> turnEndTasks({required PlayerId activePlayerId}) =>
      QueueList.from([
        const GameTask.auto(AutoGameTask.turnEndPhaseChanged()),
        const GameTask.auto(AutoGameTask.switchTurnOwner()),
        const GameTask.auto(AutoGameTask.cardDraw()),
        const GameTask.auto(AutoGameTask.checkHandLimit()),
        const GameTask.auto(AutoGameTask.advanceToMainPhase()),
        GameTask.interactive(
          InteractiveGameTask.mainPhase(activePlayerId: activePlayerId),
        ),
      ]);
}

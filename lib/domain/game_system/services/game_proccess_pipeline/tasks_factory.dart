import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

class TasksFactory {
  static QueueList<GameTask> gameStart({required PlayerId activePlayerId}) =>
      QueueList.from([
        const GameTask.gameStartDrawCards(),
        const GameTask.advanceToTurnStart(),
        const GameTask.calculateCost(),
        const GameTask.advanceToMainPhase(),
        GameTask.mainPhase(activePlayerId: activePlayerId),
      ]);
  static QueueList<GameTask> turnEndTasks({required PlayerId activePlayerId}) =>
      QueueList.from([
        const GameTask.turnEndPhaseChanged(),
        const GameTask.switchTurnOwner(),
        const GameTask.cardDraw(),
        const GameTask.checkHandLimit(),
        const GameTask.advanceToMainPhase(),
        GameTask.mainPhase(activePlayerId: activePlayerId),
      ]);
}

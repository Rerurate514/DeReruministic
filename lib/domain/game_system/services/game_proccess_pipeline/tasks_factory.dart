import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';

class TasksFactory {
  static QueueList<GameTask> get gameStart => QueueList.from([
    const GameTask.gameStartDrawCards(),
    const GameTask.advanceToTurnStart(),
    const GameTask.calculateCost(),
    const GameTask.advanceToMainPhase(),
  ]);
  static QueueList<GameTask> get turnEndTasks => QueueList.from([
    const GameTask.turnEndPhaseChanged(),
    const GameTask.switchTurnOwner(),
    const GameTask.cardDraw(),
    const GameTask.checkHandLimit(),
    const GameTask.advanceToMainPhase(),
  ]);
}

import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';

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
}

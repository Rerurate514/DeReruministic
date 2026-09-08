import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

class TasksFactory {
  static QueueList<GameTask> gameStart({required PlayerId activePlayerId}) =>
      QueueList.from([
        const .auto(.gameStartDrawCards()),
        const .auto(.advanceToTurnStart()),
        const .auto(.calculateCost()),
        const .auto(.advanceToMainPhase()),
        .interactive(
          .mainPhase(activePlayerId: activePlayerId),
        ),
      ]);

  static QueueList<GameTask> turnEndTasks({required PlayerId activePlayerId}) =>
      QueueList.from([
        const .auto(.turnEndPhaseChanged()),
        const .auto(.switchTurnOwner()),
        const .auto(.cardDraw()),
        const .auto(.checkHandLimit()),
        const .auto(.advanceToMainPhase()),
        .interactive(
          .mainPhase(activePlayerId: activePlayerId),
        ),
      ]);
}

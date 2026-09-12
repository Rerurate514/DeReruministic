import 'package:collection/collection.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
import 'package:json_annotation/json_annotation.dart';

class GameTaskQueueConverter
    implements JsonConverter<QueueList<GameTask>, List<dynamic>> {
  const GameTaskQueueConverter();

  @override
  QueueList<GameTask> fromJson(List<dynamic> json) {
    final tasks = json
        .map((e) => GameTask.fromJson(e as Map<String, dynamic>))
        .toList();
    return QueueList<GameTask>.from(tasks);
  }

  @override
  List<dynamic> toJson(QueueList<GameTask> object) {
    return object.map((e) => e.toJson()).toList();
  }
}

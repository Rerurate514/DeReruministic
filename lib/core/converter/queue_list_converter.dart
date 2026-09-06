import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

class QueueListConverter<T>
    implements JsonConverter<QueueList<T>, List<dynamic>> {
  const QueueListConverter();

  @override
  QueueList<T> fromJson(List<dynamic> json) {
    return QueueList<T>.from(json.cast<T>());
  }

  @override
  List<dynamic> toJson(QueueList<T> object) {
    return object.toList();
  }
}

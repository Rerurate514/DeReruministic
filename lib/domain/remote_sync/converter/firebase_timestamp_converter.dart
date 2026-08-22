import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FirestoreTimestampConverter implements JsonConverter<Timestamp, Object> {
  const FirestoreTimestampConverter();

  @override
  Timestamp fromJson(Object json) {
    if (json is Timestamp) return json;
    if (json is String) return Timestamp.fromDate(DateTime.parse(json));
    throw ArgumentError('Invalid timestamp format');
  }

  @override
  Object toJson(Timestamp object) => object;
}

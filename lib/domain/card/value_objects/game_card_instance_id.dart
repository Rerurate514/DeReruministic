import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'game_card_instance_id.freezed.dart';
part 'game_card_instance_id.g.dart';

@freezed
sealed class GameCardInstanceId with _$GameCardInstanceId {
  const factory GameCardInstanceId({
    required String value,
  }) = _GameCardInstanceId;

  factory GameCardInstanceId.generate() {
    return GameCardInstanceId(value: const Uuid().v4());
  }

  factory GameCardInstanceId.fromJson(Map<String, dynamic> json) =>
      _$GameCardInstanceIdFromJson(json);
}

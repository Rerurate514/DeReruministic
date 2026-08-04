import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'game_actions_id.freezed.dart';
part 'game_actions_id.g.dart';

@freezed
sealed class GameActionsId with _$GameActionsId {
  const factory GameActionsId({
    required String value,
  }) = _GameActionsId;

  factory GameActionsId.generate() {
    return GameActionsId(value: const Uuid().v4());
  }

  factory GameActionsId.fromJson(Map<String, dynamic> json) =>
      _$GameActionsIdFromJson(json);
}

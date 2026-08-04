import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'player_id.freezed.dart';
part 'player_id.g.dart';

@freezed
sealed class PlayerId with _$PlayerId {
  const factory PlayerId({
    required String value,
  }) = _PlayerId;

  factory PlayerId.generate() {
    return PlayerId(value: const Uuid().v4());
  }

  factory PlayerId.fromJson(Map<String, dynamic> json) =>
      _$PlayerIdFromJson(json);
}

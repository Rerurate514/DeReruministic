import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card_instance_id.freezed.dart';
part 'game_card_instance_id.g.dart';

@freezed
sealed class GameCardInstanceId with _$GameCardInstanceId {
  const factory GameCardInstanceId({
    required String value,
  }) = _GameCardInstanceId;

  factory GameCardInstanceId.generate(Random random) {
    final idValue = random.nextInt(1 << 32).toString();
    return GameCardInstanceId(value: idValue);
  }

  factory GameCardInstanceId.fromJson(Map<String, dynamic> json) =>
      _$GameCardInstanceIdFromJson(json);
}

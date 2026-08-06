import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'defeat_result.freezed.dart';
part 'defeat_result.g.dart';

@freezed
sealed class DefeatResult with _$DefeatResult {
  const factory DefeatResult({
    required DefeatReason reason,
    required PlayerId loserPlayerId,
  }) = _DefeatResult;

  factory DefeatResult.fromJson(Map<String, dynamic> json) =>
      _$DefeatResultFromJson(json);
}

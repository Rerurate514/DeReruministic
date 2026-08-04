import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_effect_type.freezed.dart';
part 'status_effect_type.g.dart';

@freezed
sealed class StatusEffectType with _$StatusEffectType {
  const factory StatusEffectType.buff(BuffTypes type) = StatusEffectTypeBuff;
  const factory StatusEffectType.debuff(DebuffTypes type) =
      StatusEffectTypeDebuff;

  factory StatusEffectType.fromJson(Map<String, dynamic> json) =>
      _$StatusEffectTypeFromJson(json);
}

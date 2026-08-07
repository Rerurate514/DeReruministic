import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'buff_state.freezed.dart';
part 'buff_state.g.dart';

@freezed
sealed class BuffState with _$BuffState {
  const factory BuffState({required BuffTypes buff, required int stack}) =
      _BuffState;

  factory BuffState.fromJson(Map<String, dynamic> json) =>
      _$BuffStateFromJson(json);
}

extension BuffStateDamageModifier on BuffState {
  int modifyOutgoingDamage(int currentDamage) {
    return switch (buff) {
      BuffTypes.atkBuff => currentDamage + stack,
      BuffTypes.combo => currentDamage + stack,
      _ => currentDamage,
    };
  }

  int modifyIncomingDamage(int currentDamage) {
    return switch (buff) {
      _ => currentDamage,
    };
  }
}

import 'package:dereruministic/domain/constants/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debuff_state.freezed.dart';
part 'debuff_state.g.dart';

@freezed
sealed class DebuffState with _$DebuffState {
  const factory DebuffState({
    required DebuffTypes deDebuff,
    required int stack,
  }) = _DebuffState;

  factory DebuffState.fromJson(Map<String, dynamic> json) =>
      _$DebuffStateFromJson(json);
}

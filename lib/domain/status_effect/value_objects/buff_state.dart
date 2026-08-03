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

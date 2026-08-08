import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation_result.freezed.dart';
part 'validation_result.g.dart';

@freezed
sealed class ValidationResult with _$ValidationResult {
  const ValidationResult._();

  const factory ValidationResult.success() = ValidationResultSuccess;

  const factory ValidationResult.failure({
    required ActionFailureReason reason,
  }) = ValidationResultFailure;

  factory ValidationResult.fromJson(Map<String, dynamic> json) =>
      _$ValidationResultFromJson(json);
}

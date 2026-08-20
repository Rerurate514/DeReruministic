import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_metadata.freezed.dart';
part 'system_metadata.g.dart';

@freezed
sealed class SystemMetadata with _$SystemMetadata {
  const factory SystemMetadata({
    required int seed,
    required int actionSequenceNumber,
  }) = _SystemMetadata;

  factory SystemMetadata.fromJson(Map<String, dynamic> json) =>
      _$SystemMetadataFromJson(json);
}

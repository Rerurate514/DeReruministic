import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'id.freezed.dart';
part 'id.g.dart';

@freezed
sealed class Id with _$Id {
  const factory Id({
    required String value,
  }) = _Id;

  factory Id.generate() {
    return Id(value: const Uuid().v4());
  }

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
}

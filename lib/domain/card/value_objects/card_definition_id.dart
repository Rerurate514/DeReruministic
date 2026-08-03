import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'card_definition_id.freezed.dart';
part 'card_definition_id.g.dart';

@freezed
sealed class CardDefinitionId with _$CardDefinitionId {
  const factory CardDefinitionId({
    required String value,
  }) = _CardDefinitionId;

  factory CardDefinitionId.generate() {
    return CardDefinitionId(value: const Uuid().v4());
  }

  factory CardDefinitionId.fromJson(Map<String, dynamic> json) =>
      _$CardDefinitionIdFromJson(json);
}

import 'package:dereruministic/domain/value_object/card_sub_effects.dart';
import 'package:dereruministic/domain/value_object/id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_definition.freezed.dart';
part 'card_definition.g.dart';

@freezed
sealed class CardDefinition with _$CardDefinition {
  const factory CardDefinition({
    required Id cardDefId,
    required String name,
    required int baseCost,
    // required List<CardEffect> mainEffects,
    required List<CardSubEffects> subEffects,
    required List<String> mainEffects,
  }) = _CardDefinition;

  factory CardDefinition.fromJson(Map<String, dynamic> json) =>
      _$CardDefinitionFromJson(json);
}

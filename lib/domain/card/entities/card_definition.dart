import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/common/value_object/id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_definition.freezed.dart';
part 'card_definition.g.dart';

@freezed
sealed class CardDefinition with _$CardDefinition {
  const factory CardDefinition({
    required Id cardDefId,
    required String name,
    required int baseCost,
    required List<CardEffectsDetails> effects,
    required List<CardStates> states,
  }) = _CardDefinition;

  factory CardDefinition.fromJson(Map<String, dynamic> json) =>
      _$CardDefinitionFromJson(json);
}

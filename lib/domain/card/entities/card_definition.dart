import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_definition.freezed.dart';
part 'card_definition.g.dart';

@freezed
sealed class CardDefinition with _$CardDefinition {
  const factory CardDefinition({
    required CardDefinitionId cardDefId,
    required String name,
    required int baseCost,
    required List<CardEffectsDetails> effects,
    required List<CardStates> states,
  }) = _CardDefinition;

  factory CardDefinition.fromJson(Map<String, dynamic> json) =>
      _$CardDefinitionFromJson(json);
}

extension CardDefinitionEx on CardDefinition {
  bool hasState<T extends CardStates>() {
    return states.any((state) => state is T);
  }
}

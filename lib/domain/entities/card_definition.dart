import 'package:dereruministic/domain/value_object/id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_definition.freezed.dart';

@freezed
sealed class CardDefinition with _$CardDefinition {
  const factory CardDefinition({
    required Id cardDefId,
    required String name,
    required int baseCost,
    // required List<CardEffect> mainEffects,
    // required List<CardState> subEffects,
    required List<String> mainEffects,
    required List<String> subEffects,
  }) = _CardDefinition;
}

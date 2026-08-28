import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'in_card_place.freezed.dart';

@freezed
sealed class InCardPlace with _$InCardPlace {
  const factory InCardPlace.inDeck({
    required CardDefinition defCard,
  }) = InCardDeck;

  const factory InCardPlace.inPack({
    required CardDefinition defCard,
  }) = InCardPack;
}

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'in_card_place.freezed.dart';

@freezed
sealed class InCardPlace with _$InCardPlace {
  const factory InCardPlace.inDeck({
    required int index,
    required CardDefinition defCard,
  }) = InCardDeck;

  const factory InCardPlace.inPack({
    required int index,
    required CardDefinition defCard,
  }) = InCardPack;

  @override
  int get index;

  @override
  CardDefinition get defCard;
}

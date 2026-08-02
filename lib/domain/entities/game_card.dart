import 'package:dereruministic/domain/entities/card_definition.dart';
import 'package:dereruministic/domain/value_object/id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card.freezed.dart';

@freezed
sealed class GameCard with _$GameCard {
  const factory GameCard({
    required Id instanceId,
    required CardDefinition definition,
    required int currentCost,
    required int enteredHandAtTurn,
  }) = _GameCard;
}

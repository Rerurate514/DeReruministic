import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/common/value_object/id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card.freezed.dart';
part 'game_card.g.dart';

@freezed
sealed class GameCard with _$GameCard {
  const factory GameCard({
    required Id instanceId,
    required CardDefinition definition,
    required int currentCost,
    required int enteredHandAtTurn,
  }) = _GameCard;

  factory GameCard.fromJson(Map<String, dynamic> json) =>
      _$GameCardFromJson(json);
}

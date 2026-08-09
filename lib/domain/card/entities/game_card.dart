import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card.freezed.dart';
part 'game_card.g.dart';

@freezed
sealed class GameCard with _$GameCard {
  const factory GameCard({
    required GameCardInstanceId instanceId,
    required CardDefinition definition,
    required int currentCost,
    required int enteredHandAtTurn,
    @Default([]) List<CardRuntimeStates> runtimeStates,
  }) = _GameCard;

  factory GameCard.fromJson(Map<String, dynamic> json) =>
      _$GameCardFromJson(json);
}

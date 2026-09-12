import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'in_card_hand_area.freezed.dart';

@freezed
sealed class InCardHandArea with _$InCardHandArea {
  const factory InCardHandArea({
    required GameCard gameCard,
  }) = _InCardHandArea;
}

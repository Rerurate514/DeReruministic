import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'in_card_discard_area.freezed.dart';

@freezed
sealed class InCardDiscardArea with _$InCardDiscardArea {
  const factory InCardDiscardArea({
    required GameCard gameCard,
    required int index,
  }) = _InCardDiscardArea;
}

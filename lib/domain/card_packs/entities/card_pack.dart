import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_pack.freezed.dart';
part 'card_pack.g.dart';

@freezed
abstract class CardPack with _$CardPack {
  const factory CardPack({
    required String packName,
    required List<CardDefinitionId> cardDefIds,
  }) = _CardPack;

  factory CardPack.fromJson(Map<String, dynamic> json) =>
      _$CardPackFromJson(json);
}

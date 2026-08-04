import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_setup_context.freezed.dart';

@freezed
sealed class GameSetupContext with _$GameSetupContext {
  const factory GameSetupContext({
    required Player player,
    required Player enemy,
    required List<CardDefinition> cardDefs,
    required int seed,
  }) = _GameSetupContext;
}

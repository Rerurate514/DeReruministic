import 'dart:math';

import 'package:dereruministic/domain/card_packs/data/card_packs.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_profile.g.dart';

@riverpod
Player playerProfile(Ref ref, PlayerId playerId) {
  return Player(
    id: playerId,
    name: 'TEST ENEMY',
    deckRecipe: DeckRecipe.create(
      List.generate(
        40,
        (_) =>
            allCardDefinitions[Random().nextInt(
                  allCardDefinitions.length,
                )]
                .cardDefId,
      ),
    ),
  );
}

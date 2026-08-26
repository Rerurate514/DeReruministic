import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_deck_service.g.dart';

@riverpod
CreateDeckService createDeckService(Ref ref) {
  return CreateDeckService();
}

class CreateDeckService {
  List<GameCard> execute(
    List<CardDefinition> cardAllDefs,
    DeckRecipe deckRecipe,
    Random random,
  ) {
    final defsById = {
      for (final def in cardAllDefs) def.cardDefId: def,
    };

    final cards = deckRecipe.cardDefIds.map((cardDefId) {
      final cardDef = defsById[cardDefId];
      if (cardDef == null) {
        throw ArgumentError('Unknown CardDefinitionId: $cardDefId');
      }
      return GameCard(
        instanceId: GameCardInstanceId.generate(random),
        definition: cardDef,
        currentCost: cardDef.baseCost,
        enteredHandAtTurn: 0,
        runtimeStates: cardDef.states.buildInitialRuntimeStates(),
      );
    }).toList();

    return cards..shuffle(random);
  }
}

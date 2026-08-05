import 'dart:math';

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/create_deck_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CreateDeckService createDeckService;

  const defId1 = CardDefinitionId(value: 'def_1');
  const defId2 = CardDefinitionId(value: 'def_2');
  const unknownDefId = CardDefinitionId(value: 'def_unknown');

  const cardDef1 = CardDefinition(
    cardDefId: defId1,
    name: 'Strike',
    baseCost: 1,
    effects: [],
    states: [],
  );

  const cardDef2 = CardDefinition(
    cardDefId: defId2,
    name: 'Defend',
    baseCost: 2,
    effects: [],
    states: [],
  );

  final cardAllDefs = [cardDef1, cardDef2];

  setUp(() {
    createDeckService = CreateDeckService();
  });

  group('CreateDeckService', () {
    test('deckRecipeに従ってGameCardのリストが生成される', () {
      final deckRecipe = [defId1, defId2, defId1];
      final random = Random(12345);

      final result = createDeckService.execute(
        cardAllDefs,
        deckRecipe,
        random,
      );

      expect(result.length, equals(3));

      final countDef1 = result
          .where((card) => card.definition.cardDefId == defId1)
          .length;
      final countDef2 = result
          .where((card) => card.definition.cardDefId == defId2)
          .length;

      expect(countDef1, equals(2));
      expect(countDef2, equals(1));

      for (final card in result) {
        expect(card.currentCost, equals(card.definition.baseCost));
        expect(card.enteredHandAtTurn, equals(0));
        expect(card.instanceId, isA<GameCardInstanceId>());
      }
    });

    test('生成される各GameCardのinstanceIdがユニークである', () {
      final deckRecipe = [defId1, defId1, defId1, defId1];
      final random = Random(12345);

      final result = createDeckService.execute(
        cardAllDefs,
        deckRecipe,
        random,
      );

      final instanceIds = result.map((card) => card.instanceId.value).toSet();
      expect(instanceIds.length, equals(4));
    });

    test('deckRecipeに定義が存在しないCardDefinitionIdが含まれる場合ArgumentErrorをスローする', () {
      final deckRecipe = [defId1, unknownDefId];
      final random = Random(12345);

      expect(
        () => createDeckService.execute(
          cardAllDefs,
          deckRecipe,
          random,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Unknown CardDefinitionId: $unknownDefId'),
          ),
        ),
      );
    });

    test('deckRecipeが空の場合、空のリストを返す', () {
      final deckRecipe = <CardDefinitionId>[];
      final random = Random(12345);

      final result = createDeckService.execute(
        cardAllDefs,
        deckRecipe,
        random,
      );

      expect(result, isEmpty);
    });

    test('同じシード値のRandomを渡した場合は決定論的に並び順とIDが一致する', () {
      final deckRecipe = [defId1, defId2, defId1, defId2];

      final result1 = createDeckService.execute(
        cardAllDefs,
        deckRecipe,
        Random(42),
      );

      final result2 = createDeckService.execute(
        cardAllDefs,
        deckRecipe,
        Random(42),
      );

      expect(
        result1.map((c) => c.instanceId),
        equals(result2.map((c) => c.instanceId)),
      );
      expect(
        result1.map((c) => c.definition.cardDefId),
        equals(result2.map((c) => c.definition.cardDefId)),
      );
    });
  });
}

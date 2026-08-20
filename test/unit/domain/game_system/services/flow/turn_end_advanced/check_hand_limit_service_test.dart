import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/check_hand_limit_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CheckHandLimitService service;
  late PlayerId playerAId;
  late PlayerId playerBId;

  GameState createTestGameState({
    int handSize = 3,
    int maxHandSize = 5,
    BattlePhase battlePhase = BattlePhase.mainPhase,
  }) {
    const seed = 0;

    const cardDef = CardDefinition(
      cardDefId: CardDefinitionId(value: 'def_1'),
      name: 'Strike',
      baseCost: 1,
      effects: [],
      states: [],
    );

    final dummyHand = List.generate(
      handSize,
      (i) => GameCard(
        instanceId: GameCardInstanceId(value: 'inst_$i'),
        definition: cardDef,
        currentCost: 1,
        enteredHandAtTurn: 0,
      ),
    );

    final playerA = PlayerState(
      id: playerAId,
      hand: dummyHand,
      maxHandSize: maxHandSize,
      hp: 1,
      maxHp: 1,
      shield: 1,
      currentCost: 1,
      maxCost: 4,
      deck: [],
      graveyard: [],
      exhausted: [],
      buffs: [],
      debuffs: [],
      cardsPlayedThisTurn: 1,
      pendingRecoilCost: 0,
      pendingOverloadCost: 0,
    );

    final playerB = PlayerState(
      id: playerBId,
      hand: dummyHand,
      maxHandSize: maxHandSize,
      hp: 1,
      maxHp: 1,
      shield: 1,
      currentCost: 1,
      maxCost: 4,
      deck: [],
      graveyard: [],
      exhausted: [],
      buffs: [],
      debuffs: [],
      cardsPlayedThisTurn: 1,
      pendingRecoilCost: 0,
      pendingOverloadCost: 0,
    );

    return GameState(
      phase: GamePhase(
        battlePhase: battlePhase,
        turnOwner: playerAId,
      ),
      players: {
        playerAId: playerA,
        playerBId: playerB,
      },
      metadata: const SystemMetadata(seed: seed, actionSequenceNumber: 0),
      turnCount: 0,
      initialTurnOwner: const PlayerId(value: 'player_a'),
    );
  }

  setUp(() {
    service = CheckHandLimitService();
    playerAId = const PlayerId(value: 'player_a');
    playerBId = const PlayerId(value: 'player_b');
  });

  group('CheckHandLimitService', () {
    test('手札が上限以下の場合は状態が変更されずステップも発行されないこと', () {
      final state = createTestGameState(handSize: 5);

      final result = service.execute(state) as ApplyActionResultSuccess;

      expect(result.state, equals(state));
      expect(result.steps, isEmpty);
    });

    test('手札が上限を超えている場合は破棄フェーズへ遷移しイベントが発行されること', () {
      final state = createTestGameState(handSize: 7);

      final result = service.execute(state) as ApplyActionResultSuccess;
      expect(result.state.phase.battlePhase, equals(BattlePhase.selectDiscard));
      final step = result.steps.first as GameStepEventOverflowCheckTriggered;
      expect(step.overflowCount, equals(2));
    });
  });
}

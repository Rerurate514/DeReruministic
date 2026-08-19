import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
import 'package:dereruministic/domain/card/services/consume_cost_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_effects_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_states_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/game_test_helpers.dart';
import 'apply_card_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CheckCardConditionService>(),
  MockSpec<ResolveCardEffectsService>(),
  MockSpec<ResolveCardStatesService>(),
  MockSpec<ConsumeCardService>(),
  MockSpec<ConsumeCostService>(),
])
void main() {
  const playerId = PlayerId(value: 'player1');
  const otherPlayerId = PlayerId(value: 'player2');

  late MockCheckCardConditionService mockCheckCondition;
  late MockResolveCardEffectsService mockResolveEffects;
  late MockResolveCardStatesService mockResolveStates;
  late MockConsumeCardService mockConsumeCard;
  late MockConsumeCostService mockConsumeCost;
  late ApplyPlayCardService service;

  setUp(() {
    provideDummy<ApplyActionResult>(
      ApplyActionResult.success(
        state: buildState(
          players: {playerId: buildPlayer(id: playerId)},
        ),
        steps: const [],
      ),
    );

    mockCheckCondition = MockCheckCardConditionService();
    mockResolveEffects = MockResolveCardEffectsService();
    mockResolveStates = MockResolveCardStatesService();
    mockConsumeCard = MockConsumeCardService();
    mockConsumeCost = MockConsumeCostService();
    service = ApplyPlayCardService(
      checkCardConditionService: mockCheckCondition,
      resolveCardEffectsService: mockResolveEffects,
      resolveCardStatesService: mockResolveStates,
      consumeCardService: mockConsumeCard,
      consumeCostService: mockConsumeCost,
    );
  });

  group('ApplyPlayCardService.execute', () {
    test(
      'action.playerIdがstate.playersに存在しない場合、playerNotFoundで失敗し他サービスは呼ばれない',
      () {
        const unknownPlayerId = PlayerId(value: 'unknown');
        final state = buildState(
          players: {playerId: buildPlayer(id: playerId)},
        );
        final action = buildPlayCardAction(
          cardInstanceId: 'card1',
          playerId: unknownPlayerId,
        );

        final result = service.execute(state: state, action: action);

        expect(result, isA<ApplyActionResultFailure>());
        expect(
          (result as ApplyActionResultFailure).reason,
          ActionFailureReason.playerNotFound,
        );
        verifyZeroInteractions(mockConsumeCard);
        verifyZeroInteractions(mockCheckCondition);
        verifyZeroInteractions(mockResolveEffects);
      },
    );

    test('指定カードが手札にない場合、cardNotFoundで失敗し他サービスは呼ばれない', () {
      final player = buildPlayer(id: playerId);
      final state = buildState(players: {playerId: player});
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'not_in_hand',
      );

      final result = service.execute(state: state, action: action);

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.cardNotFound,
      );
      verifyZeroInteractions(mockConsumeCard);
      verifyZeroInteractions(mockCheckCondition);
      verifyZeroInteractions(mockResolveEffects);
    });

    test('consumeCardServiceが失敗を返す場合、そのままその失敗を返しcheck/resolveは呼ばれない', () {
      const cardDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def1'),
        name: 'Strike',
        baseCost: 1,
        effects: [],
        states: [],
      );
      final card = buildCard(instanceId: 'card1', definition: cardDef);
      final player = buildPlayer(id: playerId, hand: [card]);
      final state = buildState(players: {playerId: player});
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
      );

      when(
        mockConsumeCard.execute(
          state: state,
          sourcePlayerId: playerId,
          card: card,
        ),
      ).thenReturn(
        ApplyActionResult.failure(
          state: state,
          reason: ActionFailureReason.notEnoughCost,
        ),
      );

      final result = service.execute(state: state, action: action);

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.notEnoughCost,
      );
      verifyZeroInteractions(mockCheckCondition);
      verifyZeroInteractions(mockResolveEffects);
    });

    test(
      'consumeCardService成功後、条件を満たすeffectのみがresolveCardEffectsServiceへ渡され、'
      'stepsはconsume分とresolve分が結合される',
      () {
        const damageEffect = CardEffects.damage(
          amount: 5,
          target: CardTargetTypes.enemy,
        );
        const healEffect = CardEffects.heal(
          amount: 3,
          target: CardTargetTypes.self,
        );
        const excludedEffect = CardEffects.damage(
          amount: 2,
          target: CardTargetTypes.self,
        );

        // condition == null -> 常に含まれる想定のeffect
        const detailNoCondition = CardEffectsDetails(
          cardEffect: damageEffect,
        );
        // condition ありでtrueを返すeffect
        const buffCondition = EffectConditions.targetHasBuffCondition(
          target: CardTargetTypes.self,
          buff: BuffTypes.atkBuff,
        );
        const detailConditionTrue = CardEffectsDetails(
          cardEffect: healEffect,
          effectCondition: buffCondition,
        );
        // condition ありでfalseを返す(除外される)effect
        const debuffCondition = EffectConditions.targetHasDebuffCondition(
          target: CardTargetTypes.self,
          debuff: DebuffTypes.poison,
        );
        const detailConditionFalse = CardEffectsDetails(
          cardEffect: excludedEffect,
          effectCondition: debuffCondition,
        );

        const cardDef = CardDefinition(
          cardDefId: CardDefinitionId(value: 'def1'),
          name: 'MultiEffectCard',
          baseCost: 2,
          effects: [
            detailNoCondition,
            detailConditionTrue,
            detailConditionFalse,
          ],
          states: [],
        );
        final card = buildCard(instanceId: 'card1', definition: cardDef);
        final player = buildPlayer(id: playerId, hand: [card]);
        final state = buildState(players: {playerId: player});
        final action = buildPlayCardAction(
          playerId: playerId,
          cardInstanceId: 'card1',
        );

        final playerAfterConsume = buildPlayer(id: playerId);
        final stateAfterConsume = buildState(
          players: {
            playerId: buildPlayer(id: playerId),
          },
        );
        final consumeStep = GameStepEvent.cardMovedZone(
          playerId: playerId,
          cardInstanceIds: [card.instanceId],
          zoneFrom: CardZone.hand,
          zoneTo: CardZone.graveyard,
        );

        when(
          mockConsumeCard.execute(
            state: state,
            sourcePlayerId: playerId,
            card: card,
          ),
        ).thenReturn(
          ApplyActionResult.success(
            state: stateAfterConsume,
            steps: [consumeStep],
          ),
        );

        // 各effectのcondition判定をスタブ
        when(
          mockCheckCondition.execute(
            state: stateAfterConsume,
            action: action,
            condition: null,
            cardUsedPlayer: playerAfterConsume,
          ),
        ).thenReturn(true);
        when(
          mockCheckCondition.execute(
            state: stateAfterConsume,
            action: action,
            condition: buffCondition,
            cardUsedPlayer: playerAfterConsume,
          ),
        ).thenReturn(true);
        when(
          mockCheckCondition.execute(
            state: stateAfterConsume,
            action: action,
            condition: debuffCondition,
            cardUsedPlayer: playerAfterConsume,
          ),
        ).thenReturn(false);

        final stateAfterResolve = buildState(
          players: {
            playerId: buildPlayer(id: playerId, hp: 15),
          },
        );
        const resolveStep = GameStepEvent.damageDealt(
          targetPlayerId: otherPlayerId,
          shieldDamage: 0,
          hpDamage: 5,
        );

        when(
          mockResolveEffects.execute(
            state: stateAfterConsume,
            action: action,
            effects: [damageEffect, healEffect],
          ),
        ).thenReturn(
          ApplyActionResult.success(
            state: stateAfterResolve,
            steps: [resolveStep],
          ),
        );

        when(
          mockResolveStates.execute(
            state: stateAfterResolve,
            sourcePlayerId: playerId,
            card: card,
          ),
        ).thenReturn(
          ApplyActionResult.success(
            state: stateAfterResolve,
            steps: [],
          ),
        );

        when(
          mockConsumeCost.execute(
            state: stateAfterResolve,
            sourcePlayerId: playerId,
            card: card,
          ),
        ).thenReturn(
          ApplyActionResult.success(state: stateAfterResolve, steps: []),
        );

        final result = service.execute(state: state, action: action);

        expect(result, isA<ApplyActionResultSuccess>());
        final success = result as ApplyActionResultSuccess;
        expect(success.state, stateAfterResolve);
        expect(success.steps, [consumeStep, resolveStep]);

        // excludedEffectを含む形では呼ばれていないことを確認
        verify(
          mockResolveEffects.execute(
            state: stateAfterConsume,
            action: action,
            effects: [damageEffect, healEffect],
          ),
        ).called(1);
      },
    );

    test('resolveCardEffectsが失敗した際に、正常に初期状態へとロールバックすること', () {
      const cardDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def1'),
        name: 'Strike',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 5,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(instanceId: 'card1', definition: cardDef);
      final player = buildPlayer(id: playerId, hand: [card]);
      final initialState = buildState(players: {playerId: player});
      final stateAfterConsume = buildState(players: {playerId: player});
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'card1',
      );
      final consumeStep = GameStepEvent.cardMovedZone(
        playerId: playerId,
        cardInstanceIds: [card.instanceId],
        zoneFrom: CardZone.hand,
        zoneTo: CardZone.graveyard,
      );

      when(
        mockConsumeCard.execute(
          state: initialState,
          sourcePlayerId: playerId,
          card: card,
        ),
      ).thenReturn(
        ApplyActionResult.success(
          state: stateAfterConsume,
          steps: [consumeStep],
        ),
      );

      when(
        mockResolveEffects.execute(
          state: stateAfterConsume,
          action: action,
          effects: anyNamed('effects'),
        ),
      ).thenReturn(
        ApplyActionResult.failure(
          state: stateAfterConsume,
          reason: ActionFailureReason.invalidPhase,
        ),
      );

      final result = service.execute(state: initialState, action: action);

      expect(result.state, equals(initialState));
    });
  });
}

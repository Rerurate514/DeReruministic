import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_buff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_debuff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_percentage_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_value_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/conditions_resolver.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
import 'package:dereruministic/domain/card/services/consume_cost_service.dart';
import 'package:dereruministic/domain/card/services/create_deck_service.dart';
import 'package:dereruministic/domain/card/services/deck_restoration_service.dart';
import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_apply_buff_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_apply_debuff_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_draw_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_grant_cost_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_grant_shield_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_heal_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_remove_buffs_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_remove_debuffs_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_steal_cost_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_steal_shield_effect_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_effects_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_states_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_main_phase_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/advanced_to_turn_start_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_start_draw_cards_service.dart';
import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/calculate_turn_cost_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/game_test_helpers.dart';
import 'game_flow_usecase_integration_test.mocks.dart';

class _GameStartOnlyPipelineFactory implements ITurnPipelineFactory {
  _GameStartOnlyPipelineFactory({required this.cardDrawService});

  final CardDrawService cardDrawService;

  @override
  TurnPipeline createGameStartPipeline() {
    return TurnPipeline(
      turnProcessSteps: [
        GameStartDrawCardsService(cardDrawService: cardDrawService),
        const AdvancedToTurnStartService(),
        CalculateTurnCostService(),
        const AdvanceToMainPhaseService(),
      ],
    );
  }

  @override
  TurnPipeline createTurnEndPipeline() {
    throw UnimplementedError('このテストではturnEndパイプラインは使わない');
  }
}

CardDefinition buildSimpleCardDef(String id) {
  return CardDefinition(
    cardDefId: CardDefinitionId(value: id),
    name: 'Card $id',
    baseCost: 1,
    effects: const [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: const [],
  );
}

ApplyPlayCardService buildRealApplyPlayCardService() {
  final conditionsResolver = ConditionsResolver(
    checkTargetHasBuffConditionService: CheckTargetHasBuffConditionService(),
    checkTargetHasDebuffConditionService:
        CheckTargetHasDebuffConditionService(),
    checkTargetHpPercentageConditionService:
        CheckTargetHpPercentageConditionService(),
    checkTargetHpValueConditionService: CheckTargetHpValueConditionService(),
  );
  final effectResolver = EffectResolver(
    resolveDamageEffectService: ResolveDamageEffectService(),
    resolveDrawEffectsService: ResolveDrawEffectService(
      cardDrawService: CardDrawService(
        deckRestorationService: DeckRestorationService(),
      ),
    ),
    resolveHealEffectService: ResolveHealEffectService(),
    resolveGrantShieldEffectService: ResolveGrantShieldEffectService(),
    resolveGrantCostEffectService: ResolveGrantCostEffectService(),
    resolveStealCostEffectService: ResolveStealCostEffectService(),
    resolveStealShieldEffectService: ResolveStealShieldEffectService(),
    resolveApplyBuffService: ResolveApplyBuffService(),
    resolveApplyDebuffService: ResolveApplyDebuffService(),
    resolveRemoveBuffsEffectService: ResolveRemoveBuffsEffectService(),
    resolveRemoveDebuffsEffectService: ResolveRemoveDebuffsEffectService(),
  );
  return ApplyPlayCardService(
    checkCardConditionService: CheckCardConditionService(
      conditionsResolver: conditionsResolver,
    ),
    resolveCardEffectsService: ResolveCardEffectsService(
      effectResolver: effectResolver,
    ),
    resolveCardStatesService: ResolveCardStatesService(),
    consumeCardService: ConsumeCardService(
      playCardValidator: PlayCardValidator(),
    ),
    consumeCostService: ConsumeCostService(),
  );
}

@GenerateNiceMocks([
  MockSpec<ITurnPipelineFactory>(),
  MockSpec<GameSetupService>(),
  MockSpec<TurnPipeline>(),
])
void main() {
  const playerId = PlayerId(value: 'player1');
  const enemyId = PlayerId(value: 'player2');

  late MockITurnPipelineFactory mockPipelineFactory;
  late MockGameSetupService mockGameSetupService;
  late MockTurnPipeline mockTurnPipeline;
  late GameFlowUsecase usecase;

  setUp(() {
    mockPipelineFactory = MockITurnPipelineFactory();
    mockGameSetupService = MockGameSetupService();
    mockTurnPipeline = MockTurnPipeline();

    provideDummy<ApplyActionResult>(
      ApplyActionResult.noSteps(
        state: buildState(
          players: {playerId: buildPlayer(id: playerId)},
          turnOwner: playerId,
        ),
      ),
    );
    provideDummy<TurnPipeline>(mockTurnPipeline);

    usecase = GameFlowUsecase(
      cardCatalog: const [],
      pipelineFactory: mockPipelineFactory,
      gameSetupService: mockGameSetupService,
      applyPlayCardService: buildRealApplyPlayCardService(),
    );
  });

  group('GameFlowUsecase.applyAction - GameActionPlayCard(カード効果の反映)', () {
    test('ダメージカードをプレイすると、相手のHPが減りコストが消費され手札から墓地へ移動する', () {
      const strikeDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_strike'),
        name: 'Strike',
        baseCost: 2,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 6,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'strike1',
        definition: strikeDef,
        currentCost: 2,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'strike1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedEnemy = success.state.players[enemyId]!;
      final updatedPlayer = success.state.players[playerId]!;

      expect(updatedEnemy.hp, 14); // 20 - 6
      expect(updatedPlayer.hand, isEmpty);
      expect(updatedPlayer.graveyard, [card]);

      // ステップにダメージとゾーン移動の両方が含まれる
      expect(success.steps, hasLength(2));
      expect(success.steps, contains(isA<GameStepEventCardMovedZone>()));
      expect(success.steps, contains(isA<GameStepEventDamageDealt>()));
    });

    test('回復(self)かつexhaustのカードをプレイすると、自分のHPが回復しexhaustedへ移動する', () {
      const potionDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_potion'),
        name: 'Heal Potion',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.heal(
              amount: 5,
              target: CardTargetTypes.self,
            ),
          ),
        ],
        states: [CardStates.exhaust()],
      );
      final card = buildCard(
        instanceId: 'potion1',
        definition: potionDef,
      );
      final player = buildPlayer(
        id: playerId,
        hp: 10,
        hand: [card],
      );
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'potion1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[playerId]!;

      expect(updatedPlayer.hp, 15); // 10 + 5
      expect(updatedPlayer.hand, isEmpty);
      expect(updatedPlayer.exhausted, [card]); // 墓地ではなくexhausted
      expect(updatedPlayer.graveyard, isEmpty);
    });

    test('条件付き効果は条件を満たさない場合、発動せず相手HPは変化しない', () {
      const conditionalDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_conditional'),
        name: 'Conditional Strike',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 10,
              target: CardTargetTypes.enemy,
            ),
            effectCondition: EffectConditions.targetHasBuffCondition(
              target: CardTargetTypes.enemy,
              buff: BuffTypes.atkBuff,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'cond1',
        definition: conditionalDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手はatkBuffを持っていない
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'cond1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      final updatedEnemy = success.state.players[enemyId]!;

      expect(updatedEnemy.hp, 20); // 発動していないので変化なし
      // カード移動のステップのみで、ダメージのステップは含まれない
      expect(success.steps, hasLength(1));
      expect(success.steps.single, isA<GameStepEventCardMovedZone>());
    });

    test('条件付き効果は条件を満たす場合、発動して相手HPが減る', () {
      const conditionalDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_conditional'),
        name: 'Conditional Strike',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 10,
              target: CardTargetTypes.enemy,
            ),
            effectCondition: EffectConditions.targetHasBuffCondition(
              target: CardTargetTypes.enemy,
              buff: BuffTypes.atkBuff,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'cond1',
        definition: conditionalDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手にatkBuffを付与しておく
      final enemy = buildPlayer(
        id: enemyId,
        buffs: const [BuffState(buff: BuffTypes.atkBuff, stack: 1)],
      );
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'cond1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      final updatedEnemy = success.state.players[enemyId]!;

      expect(updatedEnemy.hp, 10); // 20 - 10
      expect(success.steps, hasLength(2));
    });

    test('コストが足りない場合、カード効果は発動せず状態も一切変化しない', () {
      const expensiveDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_expensive'),
        name: 'Big Nuke',
        baseCost: 10,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 99,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'nuke1',
        definition: expensiveDef,
        currentCost: 10,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'nuke1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.notEnoughCost,
      );
      // 相手のHP・自分の手札とも一切変化していない
      expect(result.state.players[enemyId]!.hp, 20);
      expect(result.state.players[playerId]!.hand, [card]);
    });

    test('リサイクル残数が残っているダメージカードをプレイすると、効果発動後にdeckへ戻る', () {
      const recycleStrikeDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_recycle_strike'),
        name: 'Recycle Strike',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 4,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'recycle1',
        definition: recycleStrikeDef,
        runtimeStates: const [
          CardRuntimeStates.recycle(maxCount: null, remainingCount: 2),
        ],
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'recycle1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      final updatedEnemy = success.state.players[enemyId]!;
      final updatedPlayer = success.state.players[playerId]!;

      // 効果自体はきちんと発動している
      expect(updatedEnemy.hp, 16); // 20 - 4

      // 墓地ではなくdeckへ戻る
      expect(updatedPlayer.hand, isEmpty);
      expect(updatedPlayer.graveyard, isEmpty);
      expect(updatedPlayer.deck, hasLength(1));

      // 残数が1減った状態でdeckに積まれている
      final deckCard = updatedPlayer.deck.single;
      final recycleState = deckCard.runtimeStates
          .whereType<CardRuntimeStateRecycleState>()
          .single;
      expect(recycleState.remainingCount, 1);

      expect(success.steps, hasLength(2));
      final zoneStep = success.steps
          .whereType<GameStepEventCardMovedZone>()
          .single;
      expect(zoneStep.zoneTo, CardZone.deck);
    });

    test('リサイクル残数が0になるカードをプレイすると、通常通り墓地へ送られる', () {
      const recycleStrikeDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_recycle_strike'),
        name: 'Recycle Strike',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 4,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'recycle1',
        definition: recycleStrikeDef,
        runtimeStates: const [
          CardRuntimeStates.recycle(maxCount: null, remainingCount: 1),
        ],
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'recycle1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      final updatedPlayer = success.state.players[playerId]!;

      expect(updatedPlayer.deck, isEmpty);
      expect(updatedPlayer.graveyard, hasLength(1));

      final graveyardCard = updatedPlayer.graveyard.single;
      final recycleState = graveyardCard.runtimeStates
          .whereType<CardRuntimeStateRecycleState>()
          .single;
      expect(recycleState.remainingCount, 0);
    });
  });

  group('GameFlowUsecase.applyAction - GameActionPlayCard(その他の効果・条件パターン)', () {
    test('1枚のカードに複数効果(自分回復+相手ダメージ)がある場合、両方とも反映される', () {
      const comboDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_combo'),
        name: 'Life Drain',
        baseCost: 2,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 6,
              target: CardTargetTypes.enemy,
            ),
          ),
          CardEffectsDetails(
            cardEffect: CardEffects.heal(
              amount: 4,
              target: CardTargetTypes.self,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'combo1',
        definition: comboDef,
        currentCost: 2,
      );
      final player = buildPlayer(id: playerId, hp: 10, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'combo1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[enemyId]!.hp, 14); // 20 - 6
      expect(success.state.players[playerId]!.hp, 14); // 10 + 4

      // ダメージ・回復・ゾーン移動の3ステップ
      expect(success.steps, hasLength(3));
      expect(success.steps, contains(isA<GameStepEventDamageDealt>()));
      expect(success.steps, contains(isA<GameStepEventHealed>()));
      expect(success.steps, contains(isA<GameStepEventCardMovedZone>()));
    });

    test('targetHpPercentageConditionを満たさない場合、追加ダメージ効果は発動しない', () {
      const finisherDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_finisher'),
        name: 'Finisher',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 15,
              target: CardTargetTypes.enemy,
            ),
            effectCondition: EffectConditions.targetHpPercentageCondition(
              target: CardTargetTypes.enemy,
              percentage: 30,
              operator: ComparisonOperator.lessOrEqual,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'finisher1',
        definition: finisherDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手はHP満タン(30%以下ではない)なので条件を満たさない
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'finisher1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[enemyId]!.hp, 20); // 変化なし
      expect(success.steps, hasLength(1)); // ゾーン移動のみ
    });

    test('targetHpPercentageConditionを満たす場合、追加ダメージ効果が発動する', () {
      const finisherDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_finisher'),
        name: 'Finisher',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 15,
              target: CardTargetTypes.enemy,
            ),
            effectCondition: EffectConditions.targetHpPercentageCondition(
              target: CardTargetTypes.enemy,
              percentage: 30,
              operator: ComparisonOperator.lessOrEqual,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'finisher1',
        definition: finisherDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手のHPが30%(6/20)以下なので条件を満たす
      final enemy = buildPlayer(id: enemyId, hp: 5);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'finisher1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[enemyId]!.hp, 0); // 5 - 15 -> 0でクランプ
      expect(success.steps, hasLength(2));
    });

    test('targetHasDebuffConditionを満たす場合のみ発動する追加効果', () {
      const punishDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_punish'),
        name: 'Punish',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 8,
              target: CardTargetTypes.enemy,
            ),
            effectCondition: EffectConditions.targetHasDebuffCondition(
              target: CardTargetTypes.enemy,
              debuff: DebuffTypes.vulnerable,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'punish1',
        definition: punishDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemyWithoutDebuff = buildPlayer(id: enemyId);
      final stateWithout = buildState(
        players: {playerId: player, enemyId: enemyWithoutDebuff},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'punish1',
        actionSequenceNumber: 2,
      );

      final resultWithout = usecase.applyAction(
        current: stateWithout,
        action: action,
      );
      final successWithout = resultWithout as ApplyActionResultSuccess;
      expect(successWithout.state.players[enemyId]!.hp, 20); // 未発動

      // vulnerableを付与した状態で再度プレイ
      final cardAgain = buildCard(
        instanceId: 'punish2',
        definition: punishDef,
      );
      final playerAgain = buildPlayer(
        id: playerId,
        hand: [cardAgain],
      );
      final enemyWithDebuff = buildPlayer(
        id: enemyId,
        debuffs: const [
          DebuffState(debuff: DebuffTypes.vulnerable, stack: 1),
        ],
      );
      final stateWith = buildState(
        players: {playerId: playerAgain, enemyId: enemyWithDebuff},
        turnOwner: playerId,
      );
      final actionAgain = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'punish2',
        actionSequenceNumber: 2,
      );

      final resultWith = usecase.applyAction(
        current: stateWith,
        action: actionAgain,
      );
      final successWith = resultWith as ApplyActionResultSuccess;
      expect(successWith.state.players[enemyId]!.hp, 11); // 20 - (8 + 1)
    });

    test('回復量がmaxHpを超える場合、maxHpでクランプされる', () {
      const bigHealDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_big_heal'),
        name: 'Full Restore',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.heal(
              amount: 100,
              target: CardTargetTypes.self,
            ),
          ),
        ],
        states: [],
      );
      final card = buildCard(
        instanceId: 'heal1',
        definition: bigHealDef,
      );
      final player = buildPlayer(id: playerId, hp: 18, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'heal1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[playerId]!.hp, 20); // maxHpでクランプ

      final healStep = success.steps.whereType<GameStepEventHealed>().single;
      expect(healStep.amount, 2); // 実際の回復量は20-18=2
    });

    test('攻撃側のatkDebuffが大きい場合、ダメージは0未満にならず0でクランプされる', () {
      const weakStrikeDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_weak_strike'),
        name: 'Weak Strike',
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
      final card = buildCard(
        instanceId: 'weak1',
        definition: weakStrikeDef,
      );
      final player = buildPlayer(
        id: playerId,
        hand: [card],
        debuffs: const [
          DebuffState(debuff: DebuffTypes.atkDebuff, stack: 100),
        ],
      );
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'weak1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[enemyId]!.hp, 20); // ダメージ0

      final damageStep = success.steps
          .whereType<GameStepEventDamageDealt>()
          .single;
      expect(damageStep.hpDamage, 0);
      expect(damageStep.shieldDamage, 0);
    });
  });

  group('GameFlowUsecase.applyAction - GameActionPlayCard(CardStatesの影響確認)', () {
    test(
      'exhaust以外の静的flag系state(undiscardable/overload/conceal/engrave/chain/infect)は'
      'ゾーン遷移に影響せず、通常通りgraveyardへ送られる',
      () {
        const flagsDef = CardDefinition(
          cardDefId: CardDefinitionId(value: 'def_flags'),
          name: 'Flags Card',
          baseCost: 1,
          effects: [
            CardEffectsDetails(
              cardEffect: CardEffects.damage(
                amount: 3,
                target: CardTargetTypes.enemy,
              ),
            ),
          ],
          states: [
            CardStates.undiscardable(),
            CardStates.overload(amount: 2),
            CardStates.conceal(),
            CardStates.engrave(subTypeEffect: 'fire'),
            CardStates.chain(subTypeEffect: 'fire', order: 1),
            CardStates.infect(),
          ],
        );
        final card = buildCard(
          instanceId: 'flags1',
          definition: flagsDef,
        );
        final player = buildPlayer(id: playerId, hand: [card]);
        final enemy = buildPlayer(id: enemyId);
        final state = buildState(
          players: {playerId: player, enemyId: enemy},
          turnOwner: playerId,
        );
        final action = buildPlayCardAction(
          playerId: playerId,
          cardInstanceId: 'flags1',
          actionSequenceNumber: 2,
        );

        final result = usecase.applyAction(current: state, action: action);

        final success = result as ApplyActionResultSuccess;
        // 効果自体は普通に発動する
        expect(success.state.players[enemyId]!.hp, 17); // 20 - 3
        // どのstateもゾーン遷移には影響しない
        expect(success.state.players[playerId]!.graveyard, hasLength(1));
        expect(success.state.players[playerId]!.exhausted, isEmpty);
        expect(success.state.players[playerId]!.deck, isEmpty);
      },
    );

    test(
      'countdown/decay/retainのstateは、プレイ時のゾーン遷移・効果発動に影響しない',
      () {
        const timedDef = CardDefinition(
          cardDefId: CardDefinitionId(value: 'def_timed'),
          name: 'Timed Card',
          baseCost: 1,
          effects: [
            CardEffectsDetails(
              cardEffect: CardEffects.damage(
                amount: 5,
                target: CardTargetTypes.enemy,
              ),
            ),
          ],
          states: [
            CardStates.countdown(turns: 3),
            CardStates.decay(turns: 2),
            CardStates.retain(turnThreshold: 2, costReduction: 1),
          ],
        );
        final card = buildCard(
          instanceId: 'timed1',
          definition: timedDef,
        );
        final player = buildPlayer(id: playerId, hand: [card]);
        final enemy = buildPlayer(id: enemyId);
        final state = buildState(
          players: {playerId: player, enemyId: enemy},
          turnOwner: playerId,
        );
        final action = buildPlayCardAction(
          playerId: playerId,
          cardInstanceId: 'timed1',
          actionSequenceNumber: 2,
        );

        final result = usecase.applyAction(current: state, action: action);

        final success = result as ApplyActionResultSuccess;
        expect(success.state.players[enemyId]!.hp, 15); // 20 - 5
        expect(success.state.players[playerId]!.graveyard, hasLength(1));
      },
    );

    test('exhaustは、他のflag系stateやrecycle(定義)と併記されていても最優先でexhaustedへ行く', () {
      const exhaustPriorityDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_exhaust_priority'),
        name: 'Exhaust Priority',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 3,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [
          CardStates.exhaust(),
          CardStates.recycle(count: 3),
          CardStates.conceal(),
        ],
      );
      final card = buildCard(
        instanceId: 'exhaustPriority1',
        definition: exhaustPriorityDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'exhaustPriority1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[playerId]!.exhausted, hasLength(1));
      expect(success.state.players[playerId]!.deck, isEmpty);
      expect(success.state.players[playerId]!.graveyard, isEmpty);
    });

    test('recycle(count: null)は無限リサイクルとして扱われ、常にdeckへ戻る', () {
      // buildInitialRuntimeStates()は count が null の場合、
      // 意図的にruntime stateを作らない(=definition.hasState任せの無限リサイクル)。
      // そのためGameCard側もruntimeStates: []のままで表現する。
      const infiniteRecycleDef = CardDefinition(
        cardDefId: CardDefinitionId(value: 'def_infinite_recycle'),
        name: 'Infinite Recycle Card',
        baseCost: 1,
        effects: [
          CardEffectsDetails(
            cardEffect: CardEffects.damage(
              amount: 2,
              target: CardTargetTypes.enemy,
            ),
          ),
        ],
        states: [CardStates.recycle()],
      );
      final card = buildCard(
        instanceId: 'infiniteRecycle1',
        definition: infiniteRecycleDef,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildPlayCardAction(
        playerId: playerId,
        cardInstanceId: 'infiniteRecycle1',
        actionSequenceNumber: 2,
      );

      final result = usecase.applyAction(current: state, action: action);

      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[enemyId]!.hp, 18); // 効果は発動する
      expect(success.state.players[playerId]!.deck, hasLength(1));
      expect(success.state.players[playerId]!.graveyard, isEmpty);

      // remainingCountを持つruntime state自体が存在しない(=countの概念がない)
      final deckCard = success.state.players[playerId]!.deck.single;
      expect(
        deckCard.runtimeStates.whereType<CardRuntimeStateRecycleState>(),
        isEmpty,
      );
    });

    test(
      'recycle(count: 0)相当のruntime(remainingCount: 0)を持つカードは、graveyardへ送られる',
      () {
        // buildInitialRuntimeStates()がcount: 0から作るruntime stateを
        // 手動で再現(remainingCount: 0, maxCount: 0)。
        const zeroRecycleDef = CardDefinition(
          cardDefId: CardDefinitionId(value: 'def_zero_recycle'),
          name: 'Zero Recycle Card',
          baseCost: 1,
          effects: [
            CardEffectsDetails(
              cardEffect: CardEffects.damage(
                amount: 2,
                target: CardTargetTypes.enemy,
              ),
            ),
          ],
          states: [CardStates.recycle(count: 0)],
        );
        final card = buildCard(
          instanceId: 'zeroRecycle1',
          definition: zeroRecycleDef,
          runtimeStates: const [
            CardRuntimeStates.recycle(maxCount: 0, remainingCount: 0),
          ],
        );
        final player = buildPlayer(id: playerId, hand: [card]);
        final enemy = buildPlayer(id: enemyId);
        final state = buildState(
          players: {playerId: player, enemyId: enemy},
          turnOwner: playerId,
        );
        final action = buildPlayCardAction(
          playerId: playerId,
          cardInstanceId: 'zeroRecycle1',
          actionSequenceNumber: 2,
        );

        final result = usecase.applyAction(current: state, action: action);

        final success = result as ApplyActionResultSuccess;
        expect(success.state.players[enemyId]!.hp, 18); // 効果は発動する
        expect(success.state.players[playerId]!.deck, isEmpty);
        expect(success.state.players[playerId]!.graveyard, hasLength(1));
      },
    );
  });

  group('GameFlowUsecase.applyAction - GameActionGameStart', () {
    final deckRecipeA = DeckRecipe.create([
      const CardDefinitionId(value: 'def_a1'),
      const CardDefinitionId(value: 'def_a2'),
    ]);
    final deckRecipeB = DeckRecipe.create([
      const CardDefinitionId(value: 'def_b1'),
    ]);

    GameActionGameStart buildGameStartAction({int seed = 42}) {
      return GameActions.gameStart(
            id: const GameActionsId(value: 'action_start'),
            actionSequenceNumber: 1,
            playerId: playerId,
            playerBId: enemyId,
            playerADeckRecipe: deckRecipeA,
            playerBDeckRecipe: deckRecipeB,
            seed: 42,
          )
          as GameActionGameStart;
    }

    test('currentがnullでもStateErrorにならず、gameSetupServiceが呼ばれる', () {
      final action = buildGameStartAction();
      final setupState = buildState(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: playerId,
      );
      const setupStep = GameStepEvent.gameStarted(
        firstTurnPlayerId: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: [setupStep]),
      );
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);
      when(mockTurnPipeline.process(any, any)).thenReturn(
        ApplyActionResult.success(state: setupState, steps: [setupStep]),
      );

      // GameActionGameStartは_requireStateを通らないのでcurrent: nullでも動く
      final result = usecase.applyAction(current: null, action: action);

      expect(result, isA<ApplyActionResultSuccess>());
    });

    test('gameSetupServiceにactionの各フィールドとcardCatalogが正しく渡される', () {
      final action = buildGameStartAction();
      final setupState = buildState(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const []),
      );
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);
      when(mockTurnPipeline.process(any, any)).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const []),
      );

      usecase.applyAction(current: null, action: action);

      verify(
        mockGameSetupService.execute(
          playerAId: playerId,
          playerBId: enemyId,
          playerADeckRecipe: deckRecipeA,
          playerBDeckRecipe: deckRecipeB,
          cardDefs: const [], // usecaseのcardCatalogがそのまま渡される
          seed: 42,
        ),
      ).called(1);
    });

    test('gameSetupServiceが失敗を返す場合、pipelineは実行されずその失敗がそのまま返る', () {
      final action = buildGameStartAction();
      final dummyState = buildState(
        players: {playerId: buildPlayer(id: playerId)},
        turnOwner: playerId,
      );
      final failure = ApplyActionResult.failure(
        state: dummyState,
        reason: ActionFailureReason.playerNotFound,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(failure);
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);

      final result = usecase.applyAction(current: null, action: action);

      expect(result, failure);
      verifyNever(mockTurnPipeline.process(any, any));
    });

    test('gameSetupService成功時、pipeline.processにsetupのstateとstepsが渡される', () {
      final action = buildGameStartAction();
      final setupState = buildState(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: enemyId,
      );
      const setupStep = GameStepEvent.gameStarted(firstTurnPlayerId: enemyId);

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const [setupStep]),
      );
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);
      when(mockTurnPipeline.process(any, any)).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const [setupStep]),
      );

      usecase.applyAction(current: null, action: action);

      verify(
        mockTurnPipeline.process(setupState, const [setupStep]),
      ).called(1);
    });

    test('pipeline.processの結果がそのまま返る（シーケンス番号が+1された状態）', () {
      final action = buildGameStartAction();
      final setupState = buildState(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: playerId,
      );
      // pipelineがフェーズを進めた後のstateを模擬
      final pipelineState = buildState(
        players: {
          playerId: buildPlayer(id: playerId, currentCost: 5),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: playerId,
      );
      const setupStep = GameStepEvent.gameStarted(firstTurnPlayerId: playerId);
      final pipelineResult = ApplyActionResult.success(
        state: pipelineState,
        steps: const [setupStep],
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const [setupStep]),
      );
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);
      when(mockTurnPipeline.process(any, any)).thenReturn(pipelineResult);

      final result = usecase.applyAction(current: null, action: action);

      final expectedState = pipelineState.incrementalActionSequence();

      expect(
        result,
        ApplyActionResult.success(
          state: expectedState,
          steps: const [setupStep],
        ),
      );
      expect(
        (result as ApplyActionResultSuccess)
            .state
            .players[playerId]!
            .currentCost,
        5,
      );
    });

    test('pipelineが失敗を返す場合、その失敗がそのまま返る', () {
      final action = buildGameStartAction();
      final setupState = buildState(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: playerId,
      );
      final pipelineFailure = ApplyActionResult.failure(
        state: setupState,
        reason: ActionFailureReason.invalidPhase,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const []),
      );
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);
      when(mockTurnPipeline.process(any, any)).thenReturn(pipelineFailure);

      final result = usecase.applyAction(current: null, action: action);

      expect(result, pipelineFailure);
    });

    test('createTurnEndPipelineではなくcreateGameStartPipelineが使われる', () {
      final action = buildGameStartAction();
      final setupState = buildState(
        players: {
          playerId: buildPlayer(id: playerId),
          enemyId: buildPlayer(id: enemyId),
        },
        turnOwner: playerId,
      );

      when(
        mockGameSetupService.execute(
          playerAId: anyNamed('playerAId'),
          playerBId: anyNamed('playerBId'),
          playerADeckRecipe: anyNamed('playerADeckRecipe'),
          playerBDeckRecipe: anyNamed('playerBDeckRecipe'),
          cardDefs: anyNamed('cardDefs'),
          seed: anyNamed('seed'),
        ),
      ).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const []),
      );
      when(
        mockPipelineFactory.createGameStartPipeline(),
      ).thenReturn(mockTurnPipeline);
      when(mockTurnPipeline.process(any, any)).thenReturn(
        ApplyActionResult.success(state: setupState, steps: const []),
      );

      usecase.applyAction(current: null, action: action);

      verify(mockPipelineFactory.createGameStartPipeline()).called(1);
      verifyNever(mockPipelineFactory.createTurnEndPipeline());
    });
  });

  group('GameFlowUsecase.applyAction - GameActionGameStart(ターン遷移の検証)', () {
    const playerId = PlayerId(value: 'player1');
    const enemyId = PlayerId(value: 'player2');

    // 各プレイヤー10枚のデッキ。初期ドロー4枚を引いても
    // デッキが空にならないので、DeckRestorationServiceは走らない。
    final cardCatalog = List.generate(
      10,
      (i) => buildSimpleCardDef('def_$i'),
    );
    final deckRecipe = DeckRecipe.create(
      List.generate(
        10,
        (i) => CardDefinitionId(value: 'def_$i'),
      ),
    );

    late GameFlowUsecase gameStartUsecase;

    setUp(() {
      gameStartUsecase = GameFlowUsecase(
        cardCatalog: cardCatalog,
        pipelineFactory: _GameStartOnlyPipelineFactory(
          cardDrawService: CardDrawService(
            deckRestorationService: DeckRestorationService(),
          ),
        ),
        gameSetupService: GameSetupService(
          createDeckService: CreateDeckService(),
        ),
        applyPlayCardService: buildRealApplyPlayCardService(),
      );
    });

    GameActionGameStart buildGameStartAction({int seed = 42}) {
      return GameActionGameStart(
        id: const GameActionsId(value: 'action_start'),
        actionSequenceNumber: 1,
        playerId: playerId,
        playerBId: enemyId,
        playerADeckRecipe: deckRecipe,
        playerBDeckRecipe: deckRecipe,
        seed: seed,
      );
    }

    test('GameStart後、両プレイヤーが初期手札を引きデッキが正しく減っている', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final state = (result as ApplyActionResultSuccess).state;

      for (final id in [playerId, enemyId]) {
        final player = state.players[id]!;
        expect(
          player.hand,
          hasLength(GameSystemConstants.initialGameStartDrawCardsCount),
        );
        expect(
          player.deck,
          hasLength(
            deckRecipe.cardsCount -
                GameSystemConstants.initialGameStartDrawCardsCount,
          ),
        );
      }
    });

    test('GameStart後、battlePhaseがmainPhaseまで進んでいる', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      final state = (result as ApplyActionResultSuccess).state;
      expect(state.phase.battlePhase, BattlePhase.mainPhase);
      expect(state.turnCount, 1);
    });

    test('GameStart後、turnOwnerは2人のうちどちらかに決まっている', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      final state = (result as ApplyActionResultSuccess).state;
      expect(state.phase.turnOwner, anyOf(playerId, enemyId));
      expect(state.players, hasLength(2));
    });

    test('GameStart後、turnOwnerのみbaseTurnStartGainCost分コストが加算されている', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      final state = (result as ApplyActionResultSuccess).state;
      final turnOwnerId = state.phase.turnOwner;
      final nonTurnOwnerId = turnOwnerId == playerId ? enemyId : playerId;

      expect(
        state.players[turnOwnerId]!.currentCost,
        (PlayerConstants.defaultInitialCost +
                GameSystemConstants.baseTurnStartGainCost)
            .clamp(0, state.players[turnOwnerId]!.maxCost),
      );
      // 手番でない方は初期コストのまま
      expect(
        state.players[nonTurnOwnerId]!.currentCost,
        PlayerConstants.defaultInitialCost,
      );
    });

    test('GameStart後、両プレイヤーのHPが初期値で設定されている', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      final state = (result as ApplyActionResultSuccess).state;
      for (final id in [playerId, enemyId]) {
        final player = state.players[id]!;
        expect(player.hp, PlayerConstants.defaultInitialHp);
        expect(player.maxHp, PlayerConstants.defaultMaxHp);
        expect(player.shield, 0);
        expect(player.graveyard, isEmpty);
        expect(player.exhausted, isEmpty);
      }
    });

    test('GameStart後、stateのseedがactionのseedを引き継いでいる', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(seed: 12345),
      );

      final state = (result as ApplyActionResultSuccess).state;
      expect(state.metadata.seed, 12345);
    });

    test('同じseedでGameStartすると、同じ結果になる(決定的)', () {
      final result1 = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(seed: 777),
      );
      // usecaseを作り直して同条件で再実行
      final usecase2 = GameFlowUsecase(
        cardCatalog: cardCatalog,
        pipelineFactory: _GameStartOnlyPipelineFactory(
          cardDrawService: CardDrawService(
            deckRestorationService: DeckRestorationService(),
          ),
        ),
        gameSetupService: GameSetupService(
          createDeckService: CreateDeckService(),
        ),
        applyPlayCardService: buildRealApplyPlayCardService(),
      );
      final result2 = usecase2.applyAction(
        current: null,
        action: buildGameStartAction(seed: 777),
      );

      final state1 = (result1 as ApplyActionResultSuccess).state;
      final state2 = (result2 as ApplyActionResultSuccess).state;

      // 先攻・手札の中身まで含めて一致する
      expect(state2.phase.turnOwner, state1.phase.turnOwner);
      expect(
        state2.players[playerId]!.hand.map((c) => c.definition.cardDefId),
        state1.players[playerId]!.hand.map((c) => c.definition.cardDefId),
      );
      expect(
        state2.players[enemyId]!.hand.map((c) => c.definition.cardDefId),
        state1.players[enemyId]!.hand.map((c) => c.definition.cardDefId),
      );
    });

    test('GameStartのstepsに、開始・ドロー・フェーズ遷移が含まれる', () {
      final result = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );

      final steps = (result as ApplyActionResultSuccess).steps;
      expect(steps, contains(isA<GameStepEventGameStarted>()));
      expect(steps, contains(isA<GameStepEventCardsDrawn>()));
      expect(steps, contains(isA<GameStepEventCostCalculated>()));
      // turnStart / mainPhase の2回のフェーズ遷移
      expect(
        steps.whereType<GameStepEventPhaseChanged>(),
        hasLength(2),
      );
    });

    test('GameStart直後にカードをプレイでき、効果が反映される(mainPhaseに到達している証明)', () {
      final startResult = gameStartUsecase.applyAction(
        current: null,
        action: buildGameStartAction(),
      );
      final state = (startResult as ApplyActionResultSuccess).state;

      final turnOwnerId = state.phase.turnOwner;
      final opponentId = turnOwnerId == playerId ? enemyId : playerId;
      final cardToPlay = state.players[turnOwnerId]!.hand.first;

      final playResult = gameStartUsecase.applyAction(
        current: state,
        action: GameActionPlayCard(
          id: const GameActionsId(value: 'action_play'),
          actionSequenceNumber: 2,
          playerId: turnOwnerId,
          cardInstanceId: cardToPlay.instanceId,
        ),
      );

      expect(playResult, isA<ApplyActionResultSuccess>());
      final afterPlay = (playResult as ApplyActionResultSuccess).state;

      // 1ダメージのカードなので相手HPが1減る
      expect(
        afterPlay.players[opponentId]!.hp,
        PlayerConstants.defaultInitialHp - 1,
      );
      // 手札が1枚減って墓地に入る
      expect(
        afterPlay.players[turnOwnerId]!.hand,
        hasLength(GameSystemConstants.initialGameStartDrawCardsCount - 1),
      );
      expect(afterPlay.players[turnOwnerId]!.graveyard, hasLength(1));
    });
  });
}

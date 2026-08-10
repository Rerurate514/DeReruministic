import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_buff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_debuff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_percentage_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_value_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/conditions_resolver.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
import 'package:dereruministic/domain/card/services/deck_restoration_service.dart';
import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_apply_buff_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_draw_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_grant_cost_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_grant_shield_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_heal_effect_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_effects_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'game_flow_usecase_integration_test.mocks.dart';

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
    resolveApplyBuffService: ResolveApplyBuffService(),
  );
  return ApplyPlayCardService(
    checkCardConditionService: CheckCardConditionService(
      conditionsResolver: conditionsResolver,
    ),
    resolveCardEffectsService: ResolveCardEffectsService(
      effectResolver: effectResolver,
    ),
    consumeCardService: ConsumeCardService(
      playCardValidator: PlayCardValidator(),
    ),
  );
}

GameCard buildCard({
  required String instanceId,
  required CardDefinition definition,
  required int currentCost,
  List<CardRuntimeStates> runtimeStates = const [],
}) {
  return GameCard(
    instanceId: GameCardInstanceId(value: instanceId),
    definition: definition,
    currentCost: currentCost,
    enteredHandAtTurn: 0,
    runtimeStates: runtimeStates,
  );
}

PlayerState buildPlayer({
  required PlayerId id,
  int hp = 20,
  int maxHp = 20,
  int shield = 0,
  int currentCost = 3,
  List<GameCard> deck = const [],
  List<GameCard> hand = const [],
  List<GameCard> graveyard = const [],
  List<GameCard> exhausted = const [],
  List<BuffState> buffs = const [],
  List<DebuffState> debuffs = const [],
}) {
  return PlayerState(
    id: id,
    hp: hp,
    maxHp: maxHp,
    shield: shield,
    currentCost: currentCost,
    deck: deck,
    hand: hand,
    graveyard: graveyard,
    exhausted: exhausted,
    buffs: buffs,
    debuffs: debuffs,
    cardsPlayedThisTurn: 0,
    maxHandSize: 5,
    pendingRecoilCost: 0,
  );
}

GameState buildState({
  required Map<PlayerId, PlayerState> players,
  required PlayerId turnOwner,
}) {
  return GameState(
    seed: 0,
    players: players,
    phase: GamePhase(battlePhase: BattlePhase.mainPhase, turnOwner: turnOwner),
    turnCount: 0,
  );
}

GameActionPlayCard buildAction({
  required PlayerId playerId,
  required String cardInstanceId,
}) {
  return GameActionPlayCard(
    id: const GameActionsId(value: 'action_1'),
    playerId: playerId,
    cardInstanceId: GameCardInstanceId(value: cardInstanceId),
  );
}

@GenerateNiceMocks([
  MockSpec<ITurnPipelineFactory>(),
  MockSpec<GameSetupService>(),
])
void main() {
  const playerId = PlayerId(value: 'player1');
  const enemyId = PlayerId(value: 'player2');

  late GameFlowUsecase usecase;

  setUp(() {
    usecase = GameFlowUsecase(
      cardCatalog: const [],
      pipelineFactory: MockITurnPipelineFactory(),
      gameSetupService: MockGameSetupService(),
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
      final action = buildAction(playerId: playerId, cardInstanceId: 'strike1');

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
        currentCost: 1,
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
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'potion1',
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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手はatkBuffを持っていない
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'cond1');

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
        currentCost: 1,
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
      final action = buildAction(playerId: playerId, cardInstanceId: 'cond1');

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
      final action = buildAction(playerId: playerId, cardInstanceId: 'nuke1');

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
        currentCost: 1,
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
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'recycle1',
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
        currentCost: 1,
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
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'recycle1',
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
      final action = buildAction(playerId: playerId, cardInstanceId: 'combo1');

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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手はHP満タン(30%以下ではない)なので条件を満たさない
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'finisher1',
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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      // 相手のHPが30%(6/20)以下なので条件を満たす
      final enemy = buildPlayer(id: enemyId, hp: 5);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'finisher1',
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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemyWithoutDebuff = buildPlayer(id: enemyId);
      final stateWithout = buildState(
        players: {playerId: player, enemyId: enemyWithoutDebuff},
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'punish1');

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
        currentCost: 1,
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
      final actionAgain = buildAction(
        playerId: playerId,
        cardInstanceId: 'punish2',
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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hp: 18, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildAction(playerId: playerId, cardInstanceId: 'heal1');

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
        currentCost: 1,
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
      final action = buildAction(playerId: playerId, cardInstanceId: 'weak1');

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
          currentCost: 1,
        );
        final player = buildPlayer(id: playerId, hand: [card]);
        final enemy = buildPlayer(id: enemyId);
        final state = buildState(
          players: {playerId: player, enemyId: enemy},
          turnOwner: playerId,
        );
        final action = buildAction(
          playerId: playerId,
          cardInstanceId: 'flags1',
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
          currentCost: 1,
        );
        final player = buildPlayer(id: playerId, hand: [card]);
        final enemy = buildPlayer(id: enemyId);
        final state = buildState(
          players: {playerId: player, enemyId: enemy},
          turnOwner: playerId,
        );
        final action = buildAction(
          playerId: playerId,
          cardInstanceId: 'timed1',
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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'exhaustPriority1',
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
        currentCost: 1,
      );
      final player = buildPlayer(id: playerId, hand: [card]);
      final enemy = buildPlayer(id: enemyId);
      final state = buildState(
        players: {playerId: player, enemyId: enemy},
        turnOwner: playerId,
      );
      final action = buildAction(
        playerId: playerId,
        cardInstanceId: 'infiniteRecycle1',
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
          currentCost: 1,
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
        final action = buildAction(
          playerId: playerId,
          cardInstanceId: 'zeroRecycle1',
        );

        final result = usecase.applyAction(current: state, action: action);

        final success = result as ApplyActionResultSuccess;
        expect(success.state.players[enemyId]!.hp, 18); // 効果は発動する
        expect(success.state.players[playerId]!.deck, isEmpty);
        expect(success.state.players[playerId]!.graveyard, hasLength(1));
      },
    );
  });
}

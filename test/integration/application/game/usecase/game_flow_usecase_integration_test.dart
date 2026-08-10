import 'package:dereruministic/application/game/usecases/game_flow_usecase.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/services/apply_play_card_service.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_buff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_debuff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_percentage_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_value_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/conditions_resolver.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_heal_effect_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_effects_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/flows/game_start/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/i_turn_pipeline_factory.dart';
import 'package:dereruministic/domain/game_system/services/play_card_validator.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
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
    resolveHealEffectService: ResolveHealEffectService(),
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
}) {
  return GameCard(
    instanceId: GameCardInstanceId(value: instanceId),
    definition: definition,
    currentCost: currentCost,
    enteredHandAtTurn: 0,
  );
}

PlayerState buildPlayer({
  required PlayerId id,
  int hp = 20,
  int maxHp = 20,
  int shield = 0,
  int currentCost = 3,
  List<GameCard> hand = const [],
  List<GameCard> graveyard = const [],
  List<GameCard> exhausted = const [],
  List<BuffState> buffs = const [],
}) {
  return PlayerState(
    id: id,
    hp: hp,
    maxHp: maxHp,
    shield: shield,
    currentCost: currentCost,
    deck: const [],
    hand: hand,
    graveyard: graveyard,
    exhausted: exhausted,
    buffs: buffs,
    debuffs: const [],
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
  });
}

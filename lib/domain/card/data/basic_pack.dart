import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';

const List<CardDefinition> basicPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_hit'),
    name: '殴る',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 6,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_defence_stance'),
    name: '防衛スタンス',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 5,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_first_aid'),
    name: '応急手当',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 4,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_poisonous_snake_fangs'),
    name: '毒蛇の牙',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_final_below'),
    name: '追い討ち',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 8,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 6,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHasDebuffCondition(
          debuff: DebuffTypes.poison,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_shield_bash'),
    name: 'シールドバッシュ',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.stealShield(
          amount: 5,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 7,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_meditation'),
    name: '瞑想',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 2,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'naguru'),
    name: '背水の陣',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.atkBuff,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 2,
        ),
        effectCondition: EffectConditions.targetHpPercentageCondition(
          target: CardTargetTypes.self,
          percentage: 50,
          operator: ComparisonOperator.lessThan,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_purifying_blow'),
    name: '浄化の一撃',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.removeDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 99,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_energy_steal'),
    name: 'エナジースティール',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 5,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.stealCost(
          amount: 1,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_last_resort'),
    name: 'ラストリゾート',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 25,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_accumulation_talisman'),
    name: '蓄積の呪符',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 15,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.retain(
        turnThreshold: 2,
        costReduction: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_overloaded_blow'),
    name: '過負荷の一撃',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 14,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(
        amount: 2,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_time_bomb'),
    name: '時限爆弾',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 30,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.countdown(
        turns: 3,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_ominous_curse'),
    name: '不吉な詛呪',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.undiscardable(),
      CardStates.infect(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_infinite_blade'),
    name: '無限の刃',
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
      CardStates.recycle(
        count: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_secretry_stance'),
    name: '秘匿の構え',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 8,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_chain_slash'),
    name: 'チェインスラッシュ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 7,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.chain(
        subTypeEffect: 'blade_combo',
        order: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_secret_art_corrousion'),
    name: '腐食の秘術',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 3,
        ),
      ),
    ],
    states: [
      CardStates.decay(
        turns: 2,
      ),
    ],
  ),
];

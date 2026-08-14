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
    cardDefId: CardDefinitionId(value: 'basic_pack_strike'),
    name: '強打',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 12,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_heavy_swing'),
    name: '大振り',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 9,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_double_slash'),
    name: '二段斬り',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_defence_stance'),
    name: '防御スタンス',
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
    cardDefId: CardDefinitionId(value: 'basic_pack_iron_wall'),
    name: '鉄壁',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 10,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_reinforced_wall'),
    name: '強化壁',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 6,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.retain(
        turnThreshold: 1,
        costReduction: 1,
      ),
    ],
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
    cardDefId: CardDefinitionId(value: 'basic_pack_deep_breath'),
    name: '深呼吸',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 6,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_full_recovery'),
    name: '完全回復',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 20,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_focus'),
    name: '集中',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 2,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_insight'),
    name: '洞察',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
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
    cardDefId: CardDefinitionId(value: 'basic_pack_venomous_needle'),
    name: '毒針',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 2,
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
    cardDefId: CardDefinitionId(value: 'basic_pack_battle_cry'),
    name: '雄叫び',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.atkBuff,
          stacks: 1,
          target: CardTargetTypes.self,
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
    cardDefId: CardDefinitionId(value: 'basic_pack_cleansing_light'),
    name: '浄化の光',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.removeDebuff(
          debuff: DebuffTypes.poison,
          stacks: 99,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 3,
          target: CardTargetTypes.self,
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
    cardDefId: CardDefinitionId(value: 'basic_pack_provoke'),
    name: '挑発',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_weakening_strike'),
    name: '弱体化の一撃',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_forbidden_seal'),
    name: '封印の証',
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
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_all_out_attack'),
    name: '全力攻撃',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 16,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_guard_break'),
    name: 'ガードブレイク',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.stealShield(
          amount: 3,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_overwork'),
    name: '酷使',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
];

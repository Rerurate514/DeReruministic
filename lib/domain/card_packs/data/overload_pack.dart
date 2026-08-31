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

/// オーバーロードパック（反動・自傷型）
/// コスト比で明らかに過剰な出力を出す代わりに、
/// overload（反動）と自分自身へのデバフを必ず背負うハイリスクパック。
const List<CardDefinition> overloadPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_voltage_spike'),
    name: '電圧スパイク',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 8,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_power_surge'),
    name: '電力サージ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 12,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_short_circuit'),
    name: 'ショート回路',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 2,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 2),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_forced_boost'),
    name: '強制ブースト',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 2),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_emergency_power'),
    name: '緊急電源',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 3,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 2),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_burnout'),
    name: 'バーンアウト',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.atkBuff,
          stacks: 3,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.drawReduction,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 3),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_capacity_over'),
    name: 'キャパシティオーバー',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 6,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 6,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 4),
      CardStates.recycle(count: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_unstable_reactor'),
    name: '不安定な炉心',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHpPercentageCondition(
          target: CardTargetTypes.self,
          percentage: 50,
          operator: ComparisonOperator.lessThan,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 5),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_energy_drain'),
    name: 'エナジードレイン',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.stealCost(
          amount: 2,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_overdrive'),
    name: 'オーバードライブ',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.atkBuff,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.drawBoost,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_limiter_release'),
    name: 'リミッター解除',
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
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.engrave(subTypeEffect: 'overload_mark'),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_chain_reaction_ignition'),
    name: '連鎖反応・起',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 6,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 2),
      CardStates.chain(subTypeEffect: 'overload_chain', order: 1),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_chain_reaction_burst'),
    name: '連鎖反応・爆',
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
      CardStates.overload(amount: 4),
      CardStates.chain(subTypeEffect: 'overload_chain', order: 2),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_delayed_blast'),
    name: '遅延爆破',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 25,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.countdown(turns: 3),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_last_spark'),
    name: '最後の火花',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 15,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 5),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_fan_failure'),
    name: '冷却ファン故障',
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
      CardStates.decay(turns: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_forced_cooling'),
    name: '強制冷却',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 8,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.removeDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 99,
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
    cardDefId: CardDefinitionId(value: 'overload_pack_safety_lock'),
    name: 'セーフティロック',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 12,
          target: CardTargetTypes.self,
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
    states: [
      CardStates.retain(
        turnThreshold: 2,
        costReduction: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_thermal_runaway'),
    name: '熱暴走',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 20,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 6),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'overload_pack_core_meltdown'),
    name: 'コアメルトダウン',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 35,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 10),
      CardStates.exhaust(),
    ],
  ),
];

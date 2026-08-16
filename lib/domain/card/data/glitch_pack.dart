import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';

/// グリッチパック（バグ・破損）
/// decay（腐敗）・countdown（時限）・undiscardable（停滞）を軸に、
/// 手札に居座る／勝手に消えるカードで構成された不安定なパック。
/// 効果は強いが、そのほとんどが自分にもデバフを撒く。
const List<CardDefinition> glitchPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_null_pointer'),
    name: 'ヌルポインタ',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 5,
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
    states: [
      CardStates.undiscardable(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_memory_fragment'),
    name: 'メモリ断片',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [
      CardStates.decay(turns: 2),
      CardStates.undiscardable(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_dead_code'),
    name: 'デッドコード',
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
      CardStates.decay(turns: 2),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_stale_cache'),
    name: '古いキャッシュ',
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
      CardStates.decay(turns: 3),
      CardStates.undiscardable(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_race_condition'),
    name: '競合状態',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 7,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 7,
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
      CardStates.countdown(turns: 2),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_infinite_loop'),
    name: '無限ループ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.recycle(count: 6),
      CardStates.undiscardable(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_corrupted_packet'),
    name: '破損パケット',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.infect(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_ghost_process'),
    name: 'ゴーストプロセス',
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
      CardStates.conceal(),
      CardStates.decay(turns: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_bit_rot'),
    name: 'ビット腐敗',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.decay(turns: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_undefined_behavior'),
    name: '未定義動作',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 12,
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
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_frozen_thread'),
    name: '凍結スレッド',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.drawReduction,
          stacks: 1,
          target: CardTargetTypes.enemy,
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
      CardStates.decay(turns: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_data_rot'),
    name: 'データ腐食',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.decay(turns: 2),
      CardStates.infect(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_hidden_exploit'),
    name: '隠しエクスプロイト',
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
      CardStates.conceal(),
      CardStates.engrave(subTypeEffect: 'glitch_mark'),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_cascading_failure'),
    name: '連鎖障害',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 5,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'glitch_chain', order: 1),
      CardStates.decay(turns: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_total_collapse'),
    name: '全面崩壊',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 16,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 8,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHasDebuffCondition(
          debuff: DebuffTypes.vulnerable,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'glitch_chain', order: 2),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_legacy_module'),
    name: 'レガシーモジュール',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 8,
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
      CardStates.undiscardable(),
      CardStates.retain(
        turnThreshold: 2,
        costReduction: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_time_bomb'),
    name: 'タイムボム',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 20,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.countdown(turns: 4),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'glitch_pack_segfault'),
    name: 'セグメンテーション違反',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 18,
          target: CardTargetTypes.enemy,
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
    cardDefId: CardDefinitionId(value: 'glitch_pack_patch_note'),
    name: 'パッチノート',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.removeDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 99,
          target: CardTargetTypes.self,
        ),
      ),
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
    cardDefId: CardDefinitionId(value: 'glitch_pack_reformat'),
    name: '再フォーマット',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 10,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.removeDebuff(
          debuff: DebuffTypes.poison,
          stacks: 99,
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
      CardStates.exhaust(),
    ],
  ),
];

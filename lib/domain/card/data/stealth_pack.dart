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

/// ステルスパック（潜伏・準備型）
/// conceal（潜伏）・engrave（刻印）・chain（連携）・retain（保留）を全面に使い、
/// 低コストのカードを手札に貯めて一気に決めるセットアップ型パック。
const List<CardDefinition> stealthPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_silent_probe'),
    name: 'サイレントプローブ',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_shadow_scan'),
    name: 'シャドースキャン',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [
      CardStates.conceal(),
      CardStates.retain(
        turnThreshold: 1,
        costReduction: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_ghost_shell'),
    name: 'ゴーストシェル',
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
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_mark_target'),
    name: 'ターゲットマーク',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.engrave(subTypeEffect: 'stealth_mark'),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_backtrace'),
    name: 'バックトレース',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.engrave(subTypeEffect: 'stealth_mark'),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_silent_strike'),
    name: 'サイレントストライク',
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
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_infiltration_contact'),
    name: '潜入・接触',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'stealth_chain', order: 1),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_infiltration_seize'),
    name: '潜入・掌握',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.stealCost(
          amount: 1,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'stealth_chain', order: 2),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_proxy_chain'),
    name: 'プロキシチェーン',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 5,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.retain(
        turnThreshold: 2,
        costReduction: 1,
      ),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_encrypted_note'),
    name: '暗号化メモ',
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
      CardStates.retain(
        turnThreshold: 1,
        costReduction: 1,
      ),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_dead_drop'),
    name: 'デッドドロップ',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.decay(turns: 2),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_zero_footprint'),
    name: 'ゼロフットプリント',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 4,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.conceal(),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_masquerade'),
    name: 'マスカレード',
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
    states: [
      CardStates.conceal(),
      CardStates.engrave(subTypeEffect: 'stealth_mark'),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_deep_cover'),
    name: 'ディープカバー',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 10,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.guardBoost,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.conceal(),
      CardStates.retain(
        turnThreshold: 2,
        costReduction: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_signal_jam'),
    name: '信号妨害',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.drawReduction,
          stacks: 1,
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
    states: [
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_information_leak'),
    name: '情報漏洩',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 2,
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
      CardStates.undiscardable(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_persistent_hook'),
    name: '常駐フック',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.recycle(count: 5),
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_sleeper_agent'),
    name: 'スリーパーエージェント',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 18,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.countdown(turns: 3),
      CardStates.conceal(),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_blackout'),
    name: 'ブラックアウト',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.stealShield(
          amount: 6,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.stealCost(
          amount: 1,
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
      CardStates.conceal(),
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'stealth_pack_assassination'),
    name: '暗殺プロトコル',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 12,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 20,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHpPercentageCondition(
          target: CardTargetTypes.enemy,
          percentage: 50,
          operator: ComparisonOperator.lessThan,
        ),
      ),
    ],
    states: [
      CardStates.conceal(),
      CardStates.exhaust(),
    ],
  ),
];

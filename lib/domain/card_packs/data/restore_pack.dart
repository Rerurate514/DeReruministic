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

/// リストアパック（回復系）
/// 回復・再生・デバフ解除で立て直す、粘り強いパック。
const List<CardDefinition> restorePack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_quick_patch'),
    name: 'クイックパッチ',
    baseCost: 0,
    effects: [
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
    cardDefId: CardDefinitionId(value: 'restore_pack_hot_fix'),
    name: 'ホットフィックス',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 7,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_snapshot'),
    name: 'スナップショット',
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
    cardDefId: CardDefinitionId(value: 'restore_pack_auto_recovery'),
    name: '自動修復',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.regeneration,
          stacks: 3,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_regen_protocol'),
    name: 'リジェネプロトコル',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.regeneration,
          stacks: 5,
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
    cardDefId: CardDefinitionId(value: 'restore_pack_rollback'),
    name: 'ロールバック',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 12,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_defrag'),
    name: 'デフラグ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 5,
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
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_antivirus_scan'),
    name: 'ウイルススキャン',
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
          amount: 4,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_memory_optimize'),
    name: 'メモリ最適化',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.costRecovery,
          stacks: 1,
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
    cardDefId: CardDefinitionId(value: 'restore_pack_health_check'),
    name: 'ヘルスチェック',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
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
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_emergency_repair'),
    name: '緊急修復',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 5,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 10,
          target: CardTargetTypes.self,
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
    cardDefId: CardDefinitionId(value: 'restore_pack_redundancy'),
    name: '冗長構成',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 6,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 6,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_mirror_backup'),
    name: 'ミラーバックアップ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 4,
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
    cardDefId: CardDefinitionId(value: 'restore_pack_data_salvage'),
    name: 'データサルベージ',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 8,
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
    cardDefId: CardDefinitionId(value: 'restore_pack_life_support'),
    name: 'ライフサポート',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.regeneration,
          stacks: 4,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.costRecovery,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_clean_install'),
    name: 'クリーンインストール',
    baseCost: 2,
    effects: [
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
    cardDefId: CardDefinitionId(value: 'restore_pack_uptime_boost'),
    name: 'アップタイム維持',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 3,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.recycle(count: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_second_chance'),
    name: 'セカンドチャンス',
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
          amount: 2,
        ),
        effectCondition: EffectConditions.targetHpPercentageCondition(
          target: CardTargetTypes.self,
          percentage: 30,
          operator: ComparisonOperator.lessThan,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_full_restore'),
    name: '完全復旧',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 25,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'restore_pack_phoenix_protocol'),
    name: 'フェニックスプロトコル',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 15,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.regeneration,
          stacks: 5,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
];

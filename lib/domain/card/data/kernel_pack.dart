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

/// カーネルパック（リソース・ドロー系）
/// コスト操作とドロー加速で回転させる、コンボの土台になるパック。
const List<CardDefinition> kernelPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_cache_hit'),
    name: 'キャッシュヒット',
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
    cardDefId: CardDefinitionId(value: 'kernel_pack_process_scheduler'),
    name: 'プロセススケジューラ',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
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
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_thread_pool'),
    name: 'スレッドプール',
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
    cardDefId: CardDefinitionId(value: 'kernel_pack_prefetch'),
    name: 'プリフェッチ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.drawBoost,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_garbage_collection'),
    name: 'ガベージコレクション',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 2,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.heal(
          amount: 3,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_context_switch'),
    name: 'コンテキストスイッチ',
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
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_interrupt'),
    name: '割り込み処理',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.stealCost(
          amount: 1,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_dma_transfer'),
    name: 'DMA転送',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
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
    cardDefId: CardDefinitionId(value: 'kernel_pack_pipeline_boost'),
    name: 'パイプラインブースト',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.combo,
          stacks: 2,
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
    cardDefId: CardDefinitionId(value: 'kernel_pack_hyper_threading'),
    name: 'ハイパースレッディング',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 3,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_power_management'),
    name: '電源管理',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.costRecovery,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_swap_memory'),
    name: 'スワップメモリ',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 2,
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
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_syscall_chain'),
    name: 'システムコール連鎖',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'kernel_chain', order: 1),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_driver_load'),
    name: 'ドライバロード',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 1,
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
      CardStates.chain(subTypeEffect: 'kernel_chain', order: 2),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_bios_engrave'),
    name: 'BIOS書き換え',
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
      CardStates.engrave(subTypeEffect: 'kernel_boost'),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_priority_boost'),
    name: '優先度ブースト',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 1,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 1,
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
    cardDefId: CardDefinitionId(value: 'kernel_pack_deadlock_resolver'),
    name: 'デッドロック解消',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.removeDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 99,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_overclock_core'),
    name: 'コアオーバークロック',
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
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_kernel_panic'),
    name: 'カーネルパニック',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 15,
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
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'kernel_pack_root_kernel'),
    name: 'カーネル掌握',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.draw(
          amount: 3,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.grantCost(
          amount: 3,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
];

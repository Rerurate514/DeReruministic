import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';

/// ウイルスパック（デバフ系）
/// 毒・脆弱・攻撃低下などを重ねて、じわじわ相手を崩すパック。
const List<CardDefinition> virusPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_infection_seed'),
    name: '感染の種',
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
    cardDefId: CardDefinitionId(value: 'virus_pack_worm'),
    name: 'ワーム',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.infect(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_ransomware'),
    name: 'ランサムウェア',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 1,
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
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_spyware'),
    name: 'スパイウェア',
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
        cardEffect: CardEffects.draw(
          amount: 1,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_logic_bomb'),
    name: 'ロジックボム',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 5,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.countdown(turns: 2),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_rootkit'),
    name: 'ルートキット',
    baseCost: 2,
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
      CardStates.conceal(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_trojan_variant'),
    name: 'トロイの木馬・改',
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
          debuff: DebuffTypes.vulnerable,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_polymorphic'),
    name: 'ポリモーフィック型',
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
      CardStates.recycle(count: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_backdoor'),
    name: 'バックドア',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 1,
          target: CardTargetTypes.enemy,
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
    cardDefId: CardDefinitionId(value: 'virus_pack_keylogger'),
    name: 'キーロガー',
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
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_botnet'),
    name: 'ボットネット',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 5,
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
    cardDefId: CardDefinitionId(value: 'virus_pack_mutation'),
    name: 'ウイルス変異',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 4,
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
    cardDefId: CardDefinitionId(value: 'virus_pack_data_corruption'),
    name: 'データ破損',
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
          amount: 8,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHasDebuffCondition(
          debuff: DebuffTypes.vulnerable,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_memory_leak'),
    name: 'メモリリーク',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.decay(turns: 3),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_zombie_process'),
    name: 'ゾンビプロセス',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 2,
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
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_adware'),
    name: 'アドウェア',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.drawReduction,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_self_replication'),
    name: '自己複製',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.recycle(count: 5),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_toxic_payload'),
    name: '毒性ペイロード',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 2,
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
    cardDefId: CardDefinitionId(value: 'virus_pack_outbreak'),
    name: 'アウトブレイク',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.vulnerable,
          stacks: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.infect(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'virus_pack_pandemic'),
    name: 'パンデミック',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 8,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
];

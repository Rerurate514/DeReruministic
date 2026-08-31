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

/// ファイアウォールパック（防御系）
/// シールド獲得・ガード強化・反射を軸に、耐えて勝つパック。
const List<CardDefinition> firewallPack = [
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_packet_filter'),
    name: 'パケットフィルタ',
    baseCost: 1,
    effects: [
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_deep_inspection'),
    name: 'ディープインスペクション',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 12,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_access_control'),
    name: 'アクセス制御リスト',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_guard_protocol'),
    name: 'ガードプロトコル',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.guardBoost,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_reflection_shield'),
    name: 'リフレクションシールド',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.reflect,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 4,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_bastion_host'),
    name: '要塞ホスト',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 8,
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_dmz'),
    name: 'DMZ構築',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 5,
          target: CardTargetTypes.self,
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_ids'),
    name: '侵入検知システム',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 3,
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
      CardStates.recycle(count: 4),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_ips'),
    name: '侵入防止システム',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 6,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.reflect,
          stacks: 1,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_sandbox'),
    name: 'サンドボックス',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 5,
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
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_rate_limit'),
    name: 'レート制限',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 4,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.costReduction,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_vpn_tunnel'),
    name: 'VPNトンネル',
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
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_certificate'),
    name: '証明書認証',
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
        turnThreshold: 2,
        costReduction: 1,
      ),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_zero_trust'),
    name: 'ゼロトラスト',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 7,
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
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_air_gap'),
    name: 'エアギャップ',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 10,
          target: CardTargetTypes.self,
        ),
      ),
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 8,
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_counter_measure'),
    name: 'カウンターメジャー',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.reflect,
          stacks: 2,
          target: CardTargetTypes.self,
        ),
      ),
    ],
    states: [
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'firewall_pack_load_balancer'),
    name: 'ロードバランサ',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 4,
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_honeypot'),
    name: 'ハニーポット',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 5,
          target: CardTargetTypes.self,
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_iron_barrier'),
    name: '鉄壁のバリア',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
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
    cardDefId: CardDefinitionId(value: 'firewall_pack_last_defense'),
    name: '最終防衛ライン',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
          amount: 15,
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
      CardStates.exhaust(),
    ],
  ),
];

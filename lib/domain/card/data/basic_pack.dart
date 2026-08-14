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
  // ===== 攻撃系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_hit'),
    name: 'Ping',
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
    name: 'DDoS攻撃',
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
    name: 'オーバークロック',
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
    name: 'マルチスレッド攻撃',
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

  // ===== 防御系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_defence_stance'),
    name: 'ファイアウォール',
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
    name: '暗号化プロトコル',
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
    name: '多要素認証',
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

  // ===== 回復系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_first_aid'),
    name: 'バックアップ復元',
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
    name: 'システム再起動',
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
    name: 'フルリストア',
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

  // ===== ドロー/コスト系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_focus'),
    name: 'デバッグモード',
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
    name: 'ログ解析',
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
    name: 'キャッシュクリア',
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

  // ===== 毒(デバフ)系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_poisonous_snake_fangs'),
    name: 'マルウェア注入',
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
    name: 'トロイの木馬',
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
    name: '脆弱性スキャン',
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

  // ===== 奪取系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_shield_bash'),
    name: 'ゼロデイ攻撃',
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
    name: 'リソースハイジャック',
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
    cardDefId: CardDefinitionId(value: 'basic_pack_guard_break'),
    name: 'ポートスキャン',
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

  // ===== バフ系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'naguru'),
    name: 'クリティカルモード',
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
    name: 'ブースト',
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

  // ===== 浄化系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_purifying_blow'),
    name: 'システムクリーンアップ',
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
    name: 'アンチウイルス',
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

  // ===== 大技/デメリット系 =====
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_last_resort'),
    name: 'ルートキル',
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
    name: 'スロットリング',
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
    name: 'サービス拒否攻撃',
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
    name: 'レガシーコード',
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
    name: 'バッファオーバーフロー',
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
    cardDefId: CardDefinitionId(value: 'basic_pack_overwork'),
    name: '強制シャットダウン',
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

  // ===================================================
  // ここから新規追加カード
  // ===================================================
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_spam_mail'),
    name: 'スパムメール',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.poison,
          stacks: 1,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_reboot'),
    name: 'リブート',
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
    cardDefId: CardDefinitionId(value: 'basic_pack_sql_injection'),
    name: 'SQLインジェクション',
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
          stacks: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_firmware_update'),
    name: 'ファームウェア更新',
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
    cardDefId: CardDefinitionId(value: 'basic_pack_parallel_thread'),
    name: '並列スレッド生成',
    baseCost: 1,
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
    cardDefId: CardDefinitionId(value: 'basic_pack_server_crash'),
    name: 'サーバークラッシュ',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 20,
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
      CardStates.exhaust(),
    ],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_stack_overflow'),
    name: 'スタックオーバーフロー',
    baseCost: 2,
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
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_exploit_chain'),
    name: 'エクスプロイトチェーン',
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
          amount: 8,
          target: CardTargetTypes.enemy,
        ),
        effectCondition: EffectConditions.targetHasDebuffCondition(
          debuff: DebuffTypes.atkDebuff,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_deadlock'),
    name: 'デッドロック',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyDebuff(
          debuff: DebuffTypes.atkDebuff,
          stacks: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'basic_pack_overclock_boost'),
    name: 'ブーストコンパイル',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.applyBuff(
          buff: BuffTypes.atkBuff,
          stacks: 1,
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
    cardDefId: CardDefinitionId(value: 'basic_pack_data_wipe'),
    name: 'データワイプ',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.stealShield(
          amount: 4,
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
    cardDefId: CardDefinitionId(value: 'basic_pack_encryption_lock'),
    name: 'エンクリプションロック',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.grantShield(
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

import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';

/// ペイロードパック（純粋なダメージ）
///
/// 効果は damage のみ。バフ・デバフ・条件分岐は一切持たない。
/// 差別化は「打点」ではなく「CardStates の組み合わせ」で行う。
///
/// 打点の基準は basicPack に準拠：
///   コスト0 … 3〜4 / 焼却付きで5
///   コスト1 … 6    / 焼却付きで9
///   コスト2 … 12   / 焼却や反動付きで16前後
///   コスト3 … 20〜25（焼却前提）
/// これを超える打点を持つカードには必ず overload / countdown / chain などの
/// 制約が付いており、素点で上回ることはない。
const List<CardDefinition> payloadPack = [
  // ============ 0コスト帯 ============
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_probe_shot'),
    name: 'プローブショット',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 3,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  // 循環：単発は最小だが、使い回して総打点を稼ぐ
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_repeat_ping'),
    name: 'リピートピング',
    baseCost: 0,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 2,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.recycle(count: 6),
    ],
  ),
  // 停滞＋腐敗：手札を圧迫する代わりに0コスト帯では破格の4点
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_junk_packet'),
    name: 'ジャンクパケット',
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
      CardStates.undiscardable(),
      CardStates.decay(turns: 3),
    ],
  ),

  // ============ 1コスト帯 ============
  // 基準値。コスト1＝6点
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_single_strike'),
    name: 'シングルストライク',
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
  // 連携1枚目：単体では基準以下
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_chain_shot_first'),
    name: 'チェーンショット・初弾',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 4,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'payload_chain', order: 1),
    ],
  ),
  // 連携2枚目：初弾を通した時だけ基準を大きく超える
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_chain_shot_second'),
    name: 'チェーンショット・追撃',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.chain(subTypeEffect: 'payload_chain', order: 2),
    ],
  ),
  // 循環
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_pierce_shot'),
    name: 'ピアースショット',
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
      CardStates.recycle(count: 5),
    ],
  ),
  // 焼却：basicPack「オーバークロック」と同値
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_heavy_packet'),
    name: 'ヘビーパケット',
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
  // 保留：抱えて次ターンに0コストで撃つ
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_charge_shot'),
    name: 'チャージショット',
    baseCost: 1,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 8,
          target: CardTargetTypes.enemy,
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
  // 潜伏＋循環：即効性はないが繰り返し使える
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_silent_shot'),
    name: 'サイレントショット',
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
      CardStates.conceal(),
      CardStates.recycle(count: 3),
    ],
  ),
  // 反動：基準の倍の打点を反動4で買う
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_overload_fire'),
    name: '過負荷射撃',
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
  // 時限＋焼却：2ターン待てるなら大きい
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_delayed_packet'),
    name: '遅延パケット',
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
      CardStates.countdown(turns: 2),
      CardStates.exhaust(),
    ],
  ),

  // ============ 2コスト帯 ============
  // 基準値。コスト2＝12点
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_flood_attack'),
    name: 'フラッド攻撃',
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
    cardDefId: CardDefinitionId(value: 'payload_pack_burst_fire'),
    name: 'バーストファイア',
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
  // 循環：basicPack「DDoS攻撃」の派生
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_constant_shot'),
    name: 'コンスタントショット',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 10,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.recycle(count: 4),
    ],
  ),
  // 潜伏＋保留：抱え込んでコスト1の14点として撃つ
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_wide_beam'),
    name: 'ワイドビーム',
    baseCost: 2,
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
  // 反動＋焼却
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_amplification'),
    name: '増幅攻撃',
    baseCost: 2,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 16,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 3),
      CardStates.exhaust(),
    ],
  ),

  // ============ 3コスト帯 ============
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_siege_cannon'),
    name: 'シージキャノン',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 20,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [],
  ),
  // 多段＋焼却
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_barrage'),
    name: 'バラージ',
    baseCost: 3,
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
      CardStates.exhaust(),
    ],
  ),
  // パック最大打点。反動＋焼却で購入
  CardDefinition(
    cardDefId: CardDefinitionId(value: 'payload_pack_finisher'),
    name: 'フィニッシャー',
    baseCost: 3,
    effects: [
      CardEffectsDetails(
        cardEffect: CardEffects.damage(
          amount: 28,
          target: CardTargetTypes.enemy,
        ),
      ),
    ],
    states: [
      CardStates.overload(amount: 5),
      CardStates.exhaust(),
    ],
  ),
];

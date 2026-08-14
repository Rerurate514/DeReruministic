import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/presentation/utils/buff_types_ex.dart';
import 'package:dereruministic/presentation/utils/card_target_types_ex.dart';
import 'package:dereruministic/presentation/utils/debuff_types_ex.dart';

extension CardEffectsEx on CardEffects {
  String text() {
    return switch (this) {
      CardEffectDamage(:final amount, :final target) =>
        '${target.text()}に$amountダメージを与える',
      CardEffectDraw(:final amount) => 'カードを$amount枚引く',
      CardEffectDiscard(:final card) => '手札から${card.definition.name}を1枚捨てる',
      CardEffectFetchCard(:final card) => '山札から${card.definition.name}を1枚獲得する',
      CardEffectHeal(:final amount, :final target) =>
        '${target.text()}のHPを$amount回復する',
      CardEffectGrantShield(:final amount, :final target) =>
        '${target.text()}にシールドを$amount付与する',
      CardEffectGrantCost(:final amount, :final target) =>
        '${target.text()}のコストを$amount増やします',
      CardEffectStealCost(:final amount) => '相手からコストを$amount奪う',
      CardEffectStealShield(:final amount) => '相手からシールドを$amount奪う',
      CardEffectApplyBuff(:final buff, :final stacks, :final target) =>
        '${target.text()}に${buff.text()}を$stacksスタック付与する',
      CardEffectApplyDebuff(:final debuff, :final stacks, :final target) =>
        '${target.text()}に${debuff.text()}を$stacksスタック付与する',
      CardEffectRemoveBuffs(:final buff, :final stacks, :final target) =>
        '${target.text()}から${buff.text()}を$stacksスタック解除する',
      CardEffectRemoveDebuffs(:final debuff, :final stacks, :final target) =>
        '${target.text()}から${debuff.text()}を$stacksスタック解除する',
    };
  }
}

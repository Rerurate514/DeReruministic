import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/utils/buff_types_ex.dart';
import 'package:dereruministic/presentation/utils/card_target_types_ex.dart';
import 'package:dereruministic/presentation/utils/debuff_types_ex.dart';

extension CardEffectsEx on CardEffects {
  String text(AppLocalizations l10n) {
    return switch (this) {
      CardEffectDamage(:final amount, :final target) => l10n.card_effect_damage(
        target.text(l10n),
        amount,
      ),
      CardEffectDraw(:final amount) => l10n.card_effect_draw(amount),
      CardEffectDiscard(:final card) => l10n.card_effect_discard(
        card.definition.name,
      ),
      CardEffectFetchCard(:final card) => l10n.card_effect_fetch_card(
        card.definition.name,
      ),
      CardEffectHeal(:final amount, :final target) => l10n.card_effect_heal(
        target.text(l10n),
        amount,
      ),
      CardEffectGrantShield(:final amount, :final target) =>
        l10n.card_effect_grant_shield(target.text(l10n), amount),
      CardEffectGrantCost(:final amount, :final target) =>
        l10n.card_effect_grant_cost(target.text(l10n), amount),
      CardEffectStealCost(:final amount) => l10n.card_effect_steal_cost(amount),
      CardEffectStealShield(:final amount) => l10n.card_effect_steal_shield(
        amount,
      ),
      CardEffectApplyBuff(:final buff, :final stacks, :final target) =>
        l10n.card_effect_apply_buff(
          target.text(l10n),
          buff.text(),
          stacks,
        ),
      CardEffectApplyDebuff(:final debuff, :final stacks, :final target) =>
        l10n.card_effect_apply_debuff(
          target.text(l10n),
          debuff.text(),
          stacks,
        ),
      CardEffectRemoveBuffs(:final buff, :final stacks, :final target) =>
        l10n.card_effect_remove_buffs(
          target.text(l10n),
          buff.text(),
          stacks,
        ),
      CardEffectRemoveDebuffs(:final debuff, :final stacks, :final target) =>
        l10n.card_effect_remove_debuffs(
          target.text(l10n),
          debuff.text(),
          stacks,
        ),
    };
  }
}

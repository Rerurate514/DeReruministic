import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/utils/card_effects_ex.dart';
import 'package:dereruministic/presentation/utils/effect_conditions_ex.dart';

extension CardEffectsDetailsEx on CardEffectsDetails {
  String text(AppLocalizations l10n) {
    final condition = effectCondition;
    if (condition == null) return cardEffect.text(l10n);

    return '${condition.text(l10n)}、${cardEffect.text(l10n)}';
  }
}

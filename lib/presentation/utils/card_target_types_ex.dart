import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/l10n/app_localizations.dart';

extension CardTargetTypesEx on CardTargetTypes {
  String text(AppLocalizations l10n) {
    return switch (this) {
      CardTargetTypes.self => l10n.card_target_type_self,
      CardTargetTypes.enemy => l10n.card_target_type_enemy,
    };
  }
}

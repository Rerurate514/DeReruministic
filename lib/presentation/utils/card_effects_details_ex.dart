import 'package:dereruministic/domain/card/value_objects/card_effects_details.dart';
import 'package:dereruministic/presentation/utils/card_effects_ex.dart';
import 'package:dereruministic/presentation/utils/effect_conditions_ex.dart';

extension CardEffectsDetailsEx on CardEffectsDetails {
  String text() {
    final condition = effectCondition;
    if (condition == null) return cardEffect.text();

    return '${condition.text()}、${cardEffect.text()}';
  }
}

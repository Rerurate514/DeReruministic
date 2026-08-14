import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';

extension CardTargetTypesEx on CardTargetTypes {
  String text() {
    return switch (this) {
      CardTargetTypes.self => '自分',
      CardTargetTypes.enemy => '敵',
    };
  }
}

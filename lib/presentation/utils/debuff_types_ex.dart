import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';

extension DebuffTypesEx on DebuffTypes {
  String text() {
    return name;
  }
}

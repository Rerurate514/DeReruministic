import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';

extension BuffTypesEx on BuffTypes {
  String text() {
    return name;
  }
}

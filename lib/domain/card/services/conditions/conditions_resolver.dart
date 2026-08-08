import 'package:dereruministic/domain/card/services/conditions/check_target_has_buff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_has_debuff_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_percentage_condition_service.dart';
import 'package:dereruministic/domain/card/services/conditions/check_target_hp_value_condition_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conditions_resolver.g.dart';

@riverpod
ConditionsResolver conditionsResolver(Ref ref) {
  return ConditionsResolver(
    checkTargetHasBuffConditionService: ref.read(
      checkTargetHasBuffConditionServiceProvider,
    ),
    checkTargetHasDebuffConditionService: ref.read(
      checkTargetHasDebuffConditionServiceProvider,
    ),
    checkTargetHpPercentageConditionService: ref.read(
      checkTargetHpPercentageConditionServiceProvider,
    ),
    checkTargetHpValueConditionService: ref.read(
      checkTargetHpValueConditionServiceProvider,
    ),
  );
}

class ConditionsResolver {
  const ConditionsResolver({
    required this.checkTargetHasBuffConditionService,
    required this.checkTargetHasDebuffConditionService,
    required this.checkTargetHpPercentageConditionService,
    required this.checkTargetHpValueConditionService,
  });

  final CheckTargetHasBuffConditionService checkTargetHasBuffConditionService;
  final CheckTargetHasDebuffConditionService
  checkTargetHasDebuffConditionService;
  final CheckTargetHpPercentageConditionService
  checkTargetHpPercentageConditionService;
  final CheckTargetHpValueConditionService checkTargetHpValueConditionService;
}

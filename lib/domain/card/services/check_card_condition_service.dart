import 'package:dereruministic/domain/card/services/conditions/conditions_resolver.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_card_condition_service.g.dart';

@riverpod
CheckCardConditionService checkCardConditionService(Ref ref) {
  return CheckCardConditionService(
    conditionsResolver: ref.read(conditionsResolverProvider),
  );
}

class CheckCardConditionService {
  const CheckCardConditionService({
    required this.conditionsResolver,
  });

  final ConditionsResolver conditionsResolver;

  bool execute({
    required GameState current,
    required GameActionPlayCard action,
    required EffectConditions? condition,
    required PlayerState cardUsedPlayer,
  }) {
    if (condition == null) return true;
    return switch (condition) {
      EffectConditionTargetHasBuffCondition() =>
        conditionsResolver.checkTargetHasBuffConditionService.execute(
          current,
          condition,
          cardUsedPlayer,
        ),
      EffectConditionTargetHasDebuffCondition() =>
        conditionsResolver.checkTargetHasDebuffConditionService.execute(
          current,
          condition,
          cardUsedPlayer,
        ),
      EffectConditionTargetHpPercentageCondition() =>
        conditionsResolver.checkTargetHpPercentageConditionService.execute(
          current,
          condition,
          cardUsedPlayer,
        ),
      EffectConditionTargetHpValueCondition() =>
        conditionsResolver.checkTargetHpValueConditionService.execute(
          current,
          condition,
          cardUsedPlayer,
        ),
    };
  }
}

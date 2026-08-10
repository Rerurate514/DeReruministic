import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/comparison_operator.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_target_hp_value_condition_service.g.dart';

@riverpod
CheckTargetHpValueConditionService checkTargetHpValueConditionService(
  Ref ref,
) {
  return CheckTargetHpValueConditionService();
}

class CheckTargetHpValueConditionService {
  bool execute(
    GameState state,
    EffectConditionTargetHpValueCondition condition,
    PlayerState sourcePlayer,
  ) {
    final targetPlayer = condition.target.getTargetPlayer(
      state,
      sourcePlayer.id,
    );

    if (targetPlayer == null) return false;

    return condition.operator.evaluate(targetPlayer.hp, condition.value);
  }
}

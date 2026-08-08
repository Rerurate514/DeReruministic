import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_target_has_debuff_condition_service.g.dart';

@riverpod
CheckTargetHasDebuffConditionService checkTargetHasDebuffConditionService(
  Ref ref,
) {
  return CheckTargetHasDebuffConditionService();
}

class CheckTargetHasDebuffConditionService {
  bool execute(
    GameState current,
    EffectConditionTargetHasDebuffCondition condition,
    PlayerState sourcePlayer,
  ) {
    final targetPlayer = condition.target.getTargetPlayer(
      current,
      sourcePlayer.id,
    );

    return targetPlayer.debuffs.any(
      (debuffState) => debuffState.debuff == condition.debuff,
    );
  }
}

import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/card/value_objects/effect_conditions.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_target_has_buff_condition_service.g.dart';

@riverpod
CheckTargetHasBuffConditionService checkTargetHasBuffConditionService(Ref ref) {
  return CheckTargetHasBuffConditionService();
}

class CheckTargetHasBuffConditionService {
  bool execute(
    GameState state,
    EffectConditionTargetHasBuffCondition condition,
    PlayerState sourcePlayer,
  ) {
    final targetPlayer = condition.target.getTargetPlayer(
      state,
      sourcePlayer.id,
    );

    return targetPlayer.buffs.any(
      (buffState) => buffState.buff == condition.buff,
    );
  }
}

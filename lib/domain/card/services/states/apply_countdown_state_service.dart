import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/tasks_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_countdown_state_service.g.dart';

@riverpod
ApplyCountdownStateService applyCountdownStateService(Ref ref) {
  return ApplyCountdownStateService(
    checkCardConditionService: ref.read(checkCardConditionServiceProvider),
  );
}

class ApplyCountdownStateService {
  ApplyCountdownStateService({required this.checkCardConditionService});

  final CheckCardConditionService checkCardConditionService;

  ApplyActionResult execute(
    GameState state,
    PlayerId playerId,
    GameCardInstanceId instanceId,
  ) {
    final targetPlayer = state.players[playerId];
    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: .playerNotFound,
      );
    }

    final usedCard = targetPlayer.hand.firstWhereOrNull(
      (card) => card.instanceId == instanceId,
    );
    if (usedCard == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.cardNotFound,
      );
    }

    final validEffects = usedCard.definition.effects
        .where(
          (details) => checkCardConditionService.execute(
            state: state,
            condition: details.effectCondition,
            cardUsedPlayer: targetPlayer,
          ),
        )
        .map((details) => details.cardEffect);

    final tasks = TasksFactory.applyPlayCardTasks(
      cardUsedPlayerId: targetPlayer.id,
      instanceId: instanceId,
      validEffects: validEffects,
      states: usedCard.definition.states,
    );

    final newState = state.pushTasks(GameStateTaskPushPos.head, tasks);

    final step = GameStepEvent.cardPlayed(
      playerId: targetPlayer.id,
      instanceId: usedCard.instanceId,
      cardDefId: usedCard.definition.cardDefId,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

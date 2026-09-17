import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/tasks_factory.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_play_card_service.g.dart';

@riverpod
ApplyPlayCardService applyPlayCardService(Ref ref) {
  return ApplyPlayCardService(
    checkCardConditionService: ref.read(checkCardConditionServiceProvider),
  );
}

class ApplyPlayCardService {
  const ApplyPlayCardService({
    required this.checkCardConditionService,
  });

  final CheckCardConditionService checkCardConditionService;

  ApplyActionResult execute({
    required GameState state,
    required GameActionPlayCard action,
  }) {
    final cardUsedPlayer = state.players[action.playerId];
    if (cardUsedPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    final usedCard = cardUsedPlayer.hand.firstWhereOrNull(
      (card) => card.instanceId == action.instanceId,
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
            action: action,
            condition: details.effectCondition,
            cardUsedPlayer: cardUsedPlayer,
          ),
        )
        .map((details) => details.cardEffect);

    final tasks = TasksFactory.applyPlayCardTasks(
      cardUsedPlayerId: cardUsedPlayer.id,
      instanceId: usedCard.instanceId,
      validEffects: validEffects,
      states: usedCard.definition.states,
    );

    final newState = state.pushTasks(GameStateTaskPushPos.head, tasks);

    final step = GameStepEvent.cardPlayed(
      playerId: cardUsedPlayer.id,
      instanceId: usedCard.instanceId,
      cardDefId: usedCard.definition.cardDefId,
    );

    return ApplyActionResult.success(state: newState, steps: [step]);
  }
}

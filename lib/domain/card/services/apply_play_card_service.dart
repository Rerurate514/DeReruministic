import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_task.dart';
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
      (card) => card.instanceId == action.cardInstanceId,
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

    final tasks = <GameTask>[
      GameTask.auto(
        .consumePlayCost(
          playerId: cardUsedPlayer.id,
          instanceId: usedCard.instanceId,
        ),
      ),
      GameTask.auto(
        .consumeCard(
          playerId: cardUsedPlayer.id,
          instanceId: usedCard.instanceId,
        ),
      ),
      ...validEffects.map(
        (effect) => GameTask.auto(
          .applyCardEffect(
            playerId: cardUsedPlayer.id,
            effect: effect,
            target: action.target,
          ),
        ),
      ),
      ...usedCard.definition.states.map(
        (cardState) => GameTask.auto(
          .applyCardState(
            playerId: cardUsedPlayer.id,
            cardInstanceId: usedCard.instanceId,
            cardState: cardState,
          ),
        ),
      ),
    ];

    final newState = state.pushTasks(GameStateTaskPushPos.head, tasks);

    return ApplyActionResult.success(state: newState, steps: []);
  }
}

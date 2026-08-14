import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
import 'package:dereruministic/domain/card/services/consume_cost_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_effects_service.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_play_card_service.g.dart';

@riverpod
ApplyPlayCardService applyPlayCardService(Ref ref) {
  return ApplyPlayCardService(
    checkCardConditionService: ref.read(checkCardConditionServiceProvider),
    resolveCardEffectsService: ref.read(resolveCardEffectsServiceProvider),
    consumeCardService: ref.read(consumeCardServiceProvider),
    consumeCostService: ref.read(consumeCostServiceProvider),
  );
}

class ApplyPlayCardService {
  const ApplyPlayCardService({
    required this.checkCardConditionService,
    required this.resolveCardEffectsService,
    required this.consumeCardService,
    required this.consumeCostService,
  });

  final CheckCardConditionService checkCardConditionService;
  final ResolveCardEffectsService resolveCardEffectsService;
  final ConsumeCardService consumeCardService;
  final ConsumeCostService consumeCostService;

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

    final consumeResult = consumeCardService.execute(
      state: state,
      sourcePlayerId: cardUsedPlayer.id,
      card: usedCard,
    );

    if (consumeResult case ApplyActionResultFailure()) {
      return consumeResult;
    }

    final ApplyActionResultSuccess(state: asAfterConsume, steps: consumeSteps) =
        consumeResult as ApplyActionResultSuccess;

    final applyEffects = usedCard.definition.effects
        .where(
          (effect) => checkCardConditionService.execute(
            state: asAfterConsume,
            action: action,
            condition: effect.effectCondition,
            cardUsedPlayer: asAfterConsume.players[cardUsedPlayer.id]!,
          ),
        )
        .map((effectDetails) => effectDetails.cardEffect)
        .toList();

    final resolveResult = resolveCardEffectsService.execute(
      state: asAfterConsume,
      action: action,
      effects: applyEffects,
    );

    if (resolveResult case ApplyActionResultFailure()) {
      return resolveResult;
    }

    final consumeCostResult = consumeCostService.execute(
      state: resolveResult.state,
      sourcePlayerId: cardUsedPlayer.id,
      card: usedCard,
    );

    return switch (consumeCostResult) {
      ApplyActionResultFailure(:final state, :final reason) =>
        ApplyActionResult.failure(
          state: state,
          reason: reason,
        ),
      ApplyActionResultSuccess(:final state, :final steps) =>
        ApplyActionResult.success(
          state: state,
          steps: [
            ...consumeSteps,
            ...(resolveResult as ApplyActionResultSuccess).steps,
            ...steps,
          ],
        ),
    };
  }
}

import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/consume_card_service.dart';
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
  );
}

class ApplyPlayCardService {
  const ApplyPlayCardService({
    required this.checkCardConditionService,
    required this.resolveCardEffectsService,
    required this.consumeCardService,
  });

  final CheckCardConditionService checkCardConditionService;
  final ResolveCardEffectsService resolveCardEffectsService;
  final ConsumeCardService consumeCardService;

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
      current: state,
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
            current: asAfterConsume,
            action: action,
            condition: effect.effectCondition,
            cardUsedPlayer: cardUsedPlayer,
          ),
        )
        .map((effectDetails) => effectDetails.cardEffect)
        .toList();

    final resolveResult = resolveCardEffectsService.execute(
      current: asAfterConsume,
      action: action,
      effects: applyEffects,
    );

    return switch (resolveResult) {
      ApplyActionResultFailure() => resolveResult,
      ApplyActionResultSuccess(:final state, :final steps) =>
        ApplyActionResult.success(
          state: state,
          steps: [...consumeSteps, ...steps],
        ),
    };
  }
}

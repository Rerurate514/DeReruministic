import 'package:dereruministic/domain/card/services/check_card_condition_service.dart';
import 'package:dereruministic/domain/card/services/resolve_card_effects_service.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apply_play_card_service.g.dart';

@riverpod
ApplyPlayCardService applyPlayCardService(Ref ref) {
  return ApplyPlayCardService(
    checkCardConditionService: ref.read(checkCardConditionServiceProvider),
    resolveCardEffectsService: ref.read(resolveCardEffectsServiceProvider),
  );
}

class ApplyPlayCardService {
  const ApplyPlayCardService({
    required this.checkCardConditionService,
    required this.resolveCardEffectsService,
  });

  final CheckCardConditionService checkCardConditionService;
  final ResolveCardEffectsService resolveCardEffectsService;

  ApplyActionResult execute({
    required GameState state,
    required GameActionPlayCard action,
  }) {
    // TODO: ActionのplayerIdから現在のこのカードを使用したプレイヤーを選択し、
    // ActionのinstanceIdとplayerのhandからGameCardを選択し、
    // そこからeffectsResolverとstateResolverを処理する
    //
    final cardUsedPlayer = state.players[action.playerId]!;
    final cardInstanceId = action.cardInstanceId;
    final hand = cardUsedPlayer.hand;

    final usedCard = hand.firstWhere(
      (card) => card.instanceId == cardInstanceId,
    );

    final applyEffects = usedCard.definition.effects
        .where(
          (effect) => checkCardConditionService.execute(
            current: state,
            action: action,
            condition: effect.effectCondition,
            cardUsedPlayer: cardUsedPlayer,
          ),
        )
        .map((effectDetails) => effectDetails.cardEffect)
        .toList();

    //TODO
    //カードの消費処理

    return resolveCardEffectsService.execute(
      current: state,
      action: action,
      effects: applyEffects,
    );
  }
}

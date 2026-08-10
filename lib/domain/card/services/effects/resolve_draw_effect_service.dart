import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_draw_effect_service.g.dart';

@riverpod
ResolveDrawEffectService resolveDrawEffectService(Ref ref) {
  return ResolveDrawEffectService(
    cardDrawService: ref.read(cardDrawServiceProvider),
  );
}

class ResolveDrawEffectService {
  const ResolveDrawEffectService({
    required this.cardDrawService,
  });

  final CardDrawService cardDrawService;

  ApplyActionResult execute({
    required GameState state,
    required CardEffectDraw effect,
    required PlayerId sourcePlayerId,
  }) {
    final targetPlayer = state.players[sourcePlayerId];

    if (targetPlayer == null) {
      return ApplyActionResult.failure(
        state: state,
        reason: ActionFailureReason.playerNotFound,
      );
    }

    return cardDrawService.execute(
      state,
      targetPlayer.id,
      effect.amount,
    );
  }
}

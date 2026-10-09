import 'package:dereruministic/domain/card/services/move_card_zone_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_discard_effect_service.g.dart';

@riverpod
ResolveDiscardEffectService resolveDiscardEffectService(Ref ref) {
  return ResolveDiscardEffectService(
    moveCardZoneService: ref.read(moveCardZoneServiceProvider),
  );
}

class ResolveDiscardEffectService {
  const ResolveDiscardEffectService({
    required this.moveCardZoneService,
  });

  final MoveCardZoneService moveCardZoneService;

  ApplyActionResult execute({
    required GameState state,
    required CardEffectDiscard effect,
    required PlayerId sourcePlayerId,
  }) {
    return moveCardZoneService.execute(
      state: state,
      playerId: sourcePlayerId,
      instanceIds: [effect.card.instanceId],
      zoneFrom: CardZone.hand,
      zoneTo: CardZone.graveyard,
    );
  }
}

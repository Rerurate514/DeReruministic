import 'package:dereruministic/domain/card/services/move_card_zone_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_fetch_card_effect_service.g.dart';

@riverpod
ResolveFetchCardEffectService resolveFetchCardEffectService(Ref ref) {
  return ResolveFetchCardEffectService(
    moveCardZoneService: ref.read(moveCardZoneServiceProvider),
  );
}

class ResolveFetchCardEffectService {
  const ResolveFetchCardEffectService({
    required this.moveCardZoneService,
  });

  final MoveCardZoneService moveCardZoneService;

  ApplyActionResult execute({
    required GameState state,
    required CardEffectFetchCard effect,
    required PlayerId sourcePlayerId,
  }) {
    return moveCardZoneService.execute(
      state: state,
      playerId: sourcePlayerId,
      instanceIds: [effect.card.instanceId],
      zoneFrom: CardZone.deck,
      zoneTo: CardZone.hand,
    );
  }
}

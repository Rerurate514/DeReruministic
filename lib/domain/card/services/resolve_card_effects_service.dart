import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/value_objects/action_targets.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_card_effects_service.g.dart';

@riverpod
ResolveCardEffectsService resolveCardEffectsService(Ref ref) {
  return ResolveCardEffectsService(
    effectResolver: ref.read(effectResolverProvider),
  );
}

class ResolveCardEffectsService {
  const ResolveCardEffectsService({
    required this.effectResolver,
  });

  final EffectResolver effectResolver;

  ApplyActionResult execute({
    required GameState state,
    required PlayerId playerId,
    required CardEffects effect,
    ActionTargets? target,
  }) {
    return switch (effect) {
      CardEffectDamage() => effectResolver.resolveDamageEffectService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: playerId,
      ),
      CardEffectDraw() => effectResolver.resolveDrawEffectsService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: playerId,
      ),
      CardEffectDiscard() => throw UnimplementedError(),
      CardEffectFetchCard() => throw UnimplementedError(),
      CardEffectHeal() => effectResolver.resolveHealEffectService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: playerId,
      ),
      CardEffectGrantShield() =>
        effectResolver.resolveGrantShieldEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
      CardEffectGrantCost() =>
        effectResolver.resolveGrantCostEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
      CardEffectStealCost() =>
        effectResolver.resolveStealCostEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
      CardEffectStealShield() =>
        effectResolver.resolveStealShieldEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
      CardEffectApplyBuff() => effectResolver.resolveApplyBuffService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: playerId,
      ),
      CardEffectApplyDebuff() =>
        effectResolver.resolveApplyDebuffService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
      CardEffectRemoveBuffs() =>
        effectResolver.resolveRemoveBuffsEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
      CardEffectRemoveDebuffs() =>
        effectResolver.resolveRemoveDebuffsEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: playerId,
        ),
    };
  }
}

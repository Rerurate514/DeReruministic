import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
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
    required GameState current,
    required GameActionPlayCard action,
    required List<CardEffects> effects,
  }) {
    return effects.fold<ApplyActionResult>(
      ApplyActionResult.noSteps(state: current),
      (acc, effect) {
        final result = _applySingleEffect(acc.state, action, effect);
        return ApplyActionResult(
          state: result.state,
          steps: [...acc.steps, ...result.steps],
        );
      },
    );
  }

  ApplyActionResult _applySingleEffect(
    GameState current,
    GameActionPlayCard action,
    CardEffects effect,
  ) {
    final sourcePlayerId = action.playerId;

    return switch (effect) {
      CardEffectDamage() => effectResolver.resolveDamageEffectService.execute(
        state: current,
        effect: effect,
        sourcePlayerId: action.playerId,
        targetPlayerId: effect.target.getTargetPlayerId(
          current,
          sourcePlayerId,
        ),
      ),
      CardEffectDraw() => throw UnimplementedError(),
      CardEffectDiscard() => throw UnimplementedError(),
      CardEffectFetchCard() => throw UnimplementedError(),
      CardEffectHeal() => effectResolver.resolveHealEffectService.execute(
        state: current,
        effect: effect,
        sourcePlayerId: action.playerId,
      ),
      CardEffectGrantShield() => throw UnimplementedError(),
      CardEffectGrantCost() => throw UnimplementedError(),
      CardEffectStealCost() => throw UnimplementedError(),
      CardEffectStealShield() => throw UnimplementedError(),
      CardEffectApplyBuff() => throw UnimplementedError(),
      CardEffectApplyDebuff() => throw UnimplementedError(),
      CardEffectRemoveBuffs() => throw UnimplementedError(),
      CardEffectRemoveDebuffs() => throw UnimplementedError(),
    };
  }
}

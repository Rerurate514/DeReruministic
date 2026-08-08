import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/card/value_objects/card_target_types.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
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
    var currentState = current;
    final allSteps = <GameStepEvent>[];

    for (final effect in effects) {
      final result = _applySingleEffect(currentState, action, effect);

      if (result case ApplyActionResultFailure()) {
        return result;
      }

      currentState = result.state;
      allSteps.addAll((result as ApplyActionResultSuccess).steps);
    }

    return ApplyActionResult.success(
      state: currentState,
      steps: allSteps,
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

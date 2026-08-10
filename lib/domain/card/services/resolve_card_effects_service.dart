import 'package:dereruministic/domain/card/services/effects/effect_resolver.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
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
    required GameState state,
    required GameActionPlayCard action,
    required List<CardEffects> effects,
  }) {
    var currentState = state;
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
    GameState state,
    GameActionPlayCard action,
    CardEffects effect,
  ) {
    return switch (effect) {
      CardEffectDamage() => effectResolver.resolveDamageEffectService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: action.playerId,
      ),
      CardEffectDraw() => effectResolver.resolveDrawEffectsService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: action.playerId,
      ),
      CardEffectDiscard() => throw UnimplementedError(),
      CardEffectFetchCard() => throw UnimplementedError(),
      CardEffectHeal() => effectResolver.resolveHealEffectService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: action.playerId,
      ),
      CardEffectGrantShield() =>
        effectResolver.resolveGrantShieldEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: action.playerId,
        ),
      CardEffectGrantCost() =>
        effectResolver.resolveGrantCostEffectService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: action.playerId,
        ),
      CardEffectStealCost() => throw UnimplementedError(),
      CardEffectStealShield() => throw UnimplementedError(),
      CardEffectApplyBuff() => effectResolver.resolveApplyBuffService.execute(
        state: state,
        effect: effect,
        sourcePlayerId: action.playerId,
      ),
      CardEffectApplyDebuff() =>
        effectResolver.resolveApplyDebuffService.execute(
          state: state,
          effect: effect,
          sourcePlayerId: action.playerId,
        ),
      CardEffectRemoveBuffs() => throw UnimplementedError(),
      CardEffectRemoveDebuffs() => throw UnimplementedError(),
    };
  }
}

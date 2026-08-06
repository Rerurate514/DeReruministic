import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_card_effects_service.g.dart';

@riverpod
ResolveCardEffectsService resolveCardEffectsService(Ref ref) {
  return ResolveCardEffectsService();
}

class ResolveCardEffectsService {
  ApplyActionResult execute(GameState current, List<CardEffects> effects) {
    return effects.fold<ApplyActionResult>(
      ApplyActionResult.noSteps(state: current),
      (acc, effect) {
        final result = _applySingleEffect(acc.state, effect);
        return ApplyActionResult(
          state: result.state,
          steps: [...acc.steps, ...result.steps],
        );
      },
    );
  }

  ApplyActionResult _applySingleEffect(GameState current, CardEffects effect) {
    return switch (effect) {
      // TODO: Handle this case.
      CardEffectDamage() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectDraw() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectDiscard() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectFetchCard() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectHeal() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectGrantShield() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectGrantCost() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectStealCost() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectStealShield() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectApplyBuff() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectApplyDebuff() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectRemoveBuffs() => throw UnimplementedError(),
      // TODO: Handle this case.
      CardEffectRemoveDebuffs() => throw UnimplementedError(),
    };
  }
}

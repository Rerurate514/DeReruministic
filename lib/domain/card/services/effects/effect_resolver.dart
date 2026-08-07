import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_heal_effect_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'effect_resolver.g.dart';

@riverpod
EffectResolver effectResolver(Ref ref) {
  return EffectResolver(
    resolveDamageEffectService: ref.read(resolveDamageEffectServiceProvider),
    resolveHealEffectService: ref.read(resolveHealEffectServiceProvider),
  );
}

class EffectResolver {
  const EffectResolver({
    required this.resolveDamageEffectService,
    required this.resolveHealEffectService,
  });

  final ResolveDamageEffectService resolveDamageEffectService;
  final ResolveHealEffectService resolveHealEffectService;
}

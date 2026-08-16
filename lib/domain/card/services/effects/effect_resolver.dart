import 'package:dereruministic/domain/card/services/effects/resolve_apply_buff_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_apply_debuff_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_damage_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_draw_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_grant_cost_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_grant_shield_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_heal_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_remove_buffs_effect_service.dart';
import 'package:dereruministic/domain/card/services/effects/resolve_remove_debuffs_effect_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'effect_resolver.g.dart';

@riverpod
EffectResolver effectResolver(Ref ref) {
  return EffectResolver(
    resolveDamageEffectService: ref.read(resolveDamageEffectServiceProvider),
    resolveDrawEffectsService: ref.read(resolveDrawEffectServiceProvider),
    resolveHealEffectService: ref.read(resolveHealEffectServiceProvider),
    resolveGrantShieldEffectService: ref.read(
      resolveGrantShieldEffectServiceProvider,
    ),
    resolveGrantCostEffectService: ref.read(
      resolveGrantCostEffectServiceProvider,
    ),
    resolveApplyBuffService: ref.read(resolveApplyBuffServiceProvider),
    resolveApplyDebuffService: ref.read(resolveApplyDebuffServiceProvider),
    resolveRemoveBuffsEffectService: ref.read(
      resolveRemoveBuffsEffectServiceProvider,
    ),
    resolveRemoveDebuffsEffectService: ref.read(
      resolveRemoveDebuffsEffectServiceProvider,
    ),
  );
}

class EffectResolver {
  const EffectResolver({
    required this.resolveDamageEffectService,
    required this.resolveDrawEffectsService,
    required this.resolveHealEffectService,
    required this.resolveGrantShieldEffectService,
    required this.resolveGrantCostEffectService,
    required this.resolveApplyBuffService,
    required this.resolveApplyDebuffService,
    required this.resolveRemoveBuffsEffectService,
    required this.resolveRemoveDebuffsEffectService,
  });

  final ResolveDamageEffectService resolveDamageEffectService;
  final ResolveDrawEffectService resolveDrawEffectsService;
  final ResolveHealEffectService resolveHealEffectService;
  final ResolveGrantShieldEffectService resolveGrantShieldEffectService;
  final ResolveGrantCostEffectService resolveGrantCostEffectService;
  final ResolveApplyBuffService resolveApplyBuffService;
  final ResolveApplyDebuffService resolveApplyDebuffService;
  final ResolveRemoveBuffsEffectService resolveRemoveBuffsEffectService;
  final ResolveRemoveDebuffsEffectService resolveRemoveDebuffsEffectService;
}

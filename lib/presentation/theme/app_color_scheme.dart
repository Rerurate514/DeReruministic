import 'package:flutter/material.dart';
import 'package:theme_palette_generator/theme_palette_generator.dart';

part 'app_color_scheme.theme.g.dart';

@ThemePalette()
sealed class AppColorScheme extends ThemeExtension<AppColorScheme>
    with _$AppColorScheme {
  const factory AppColorScheme({
    // 1. ブランド・基本UI
    required Color brandColor,
    required Color brandSecondary,
    required Color brandTertiary,
    required Color surfaceBackground,
    required Color surfaceContainer,
    required Color textPrimary,
    required Color textSecondary,
    required Color outline,
    required Color outlineVariant,

    // 2. ボタン・インタラクティブUI
    required Color buttonPrimary,
    required Color buttonSecondary,

    // 3. リソース・戦況 (HP/Shield/Cost)
    required Color costDp,
    required Color playerHp,
    required Color enemyHp,
    required Color shield,

    // 4. バフ・回復系
    required Color buff,
    required Color hpHeal,
    required Color comboBoost,

    // 5. デバフ・状態異常系
    required Color debuff,
    required Color poison,
    required Color recoil,

    // 6. カード領域 (Card Zones)
    required Color zoneDeck,
    required Color zoneGraveyard,
    required Color zoneExhausted,

    // 7. カード属性・特殊状態 (Card Effect States)
    required Color stateExhausted,
    required Color stateUndiscardable,
    required Color stateRecycle,
    required Color stateOverload,
    required Color stateConceal,
    required Color stateRetain,
    required Color stateEngrave,
    required Color stateChain,
    required Color stateCountdown,
    required Color stateDecay,
    required Color stateInfect,
  }) = _AppColorScheme;
}

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
    required Color comboBoost, // 連撃用
    // 5. デバフ・状態異常系
    required Color debuff,
    required Color poison, // 毒 (HP直撃)
    required Color recoil, // 反動・コスト阻害
    // 6. カード属性・状態 (CardState)
    required Color stateBurn, // 焼却 (除外)
    required Color stateRecycle, // 循環 (山札底へ)
    required Color stateInfect, // 感染 (相手山札底へ)
    required Color stateHold, // 保留・時限・腐敗 (手札滞在系)
  }) = _AppColorScheme;
}

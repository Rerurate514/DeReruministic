import 'package:flutter/material.dart';
import 'package:theme_palette_generator/theme_palette_generator.dart';

part 'app_color_scheme.theme.g.dart';

@ThemePalette()
sealed class AppColorScheme extends ThemeExtension<AppColorScheme>
    with _$AppColorScheme {
  const factory AppColorScheme({
    // 1. ブランド・基本UI
    required Color brandColor,
    required Color surfaceBackground,
    required Color textPrimary,

    // 2. リソース・戦況
    required Color costDp,
    required Color playerHp,
    required Color enemyHp,
    required Color shield,

    // 3. 状態異常（ポジティブ / ネガティブ）
    required Color buff,
    required Color debuff,
    required Color stateBurn, // 焼却用など特に強調したい特殊状態
  }) = _AppColorScheme;
}

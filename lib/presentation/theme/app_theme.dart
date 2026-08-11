import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

const lightCustomTheme = AppColorScheme(
  // 1. ブランド・基本UI
  brandColor: Color(0xFFE65100),
  brandSecondary: Color(0xFF00B8D4),
  brandTertiary: Color(0xFFD50000),
  surfaceBackground: Color(0xFFFAFAFA),
  surfaceContainer: Color(0xFFEEEEEE),
  textPrimary: Color(0xFF1D1D1F),
  textSecondary: Color(0xFF6E6E73),
  outline: Color(0xFFD1D1D6),
  outlineVariant: Color(0xFFE5E5EA),
  // 2. ボタン・インタラクティブUI
  buttonPrimary: Color(0xFFFFCCBC),
  buttonSecondary: Color(0xFFE0E0E0),
  // 3. リソース・戦況
  costDp: Color(0xFF00B8D4),
  playerHp: Color(0xFF2E7D32),
  enemyHp: Color(0xFFC62828),
  shield: Color(0xFF00838F),
  // 4. バフ・回復系
  buff: Color(0xFF00B8D4),
  hpHeal: Color(0xFF4CAF50),
  comboBoost: Color(0xFFFF8F00),
  // 5. デバフ・状態異常系
  debuff: Color(0xFFD50000),
  poison: Color(0xFF8E24AA),
  recoil: Color(0xFFBF360C),
  // 6. カード属性・状態
  stateBurn: Color(0xFFD50000),
  stateRecycle: Color(0xFF00B8D4),
  stateInfect: Color(0xFF6A1B9A),
  stateHold: Color(0xFFEF6C00),
);

const darkCustomTheme = AppColorScheme(
  // 1. ブランド・基本UI (画像から直接抽出)
  brandColor: Color(0xFFFF6B00),
  brandSecondary: Color(0xFF00F0FF),
  brandTertiary: Color(0xFFFF003C),
  surfaceBackground: Color(0xFF121417),
  surfaceContainer: Color(0xFF1C1E22),
  textPrimary: Color(0xFFFFFFFF),
  textSecondary: Color(0xFFF5B5A1),
  outline: Color(0xFF3A2B28),
  outlineVariant: Color(0xFF25282D),
  // 2. ボタン・インタラクティブUI
  buttonPrimary: Color(0xFFF5B5A1),
  buttonSecondary: Color(0xFF25282D),
  // 3. リソース・戦況
  costDp: Color(0xFF00F0FF),
  playerHp: Color(0xFFF5B5A1),
  enemyHp: Color(0xFFFF003C),
  shield: Color(0xFF727375),
  // 4. バフ・回復系
  buff: Color(0xFF00F0FF),
  hpHeal: Color(0xFF80CBC4),
  comboBoost: Color(0xFFFF6B00),
  // 5. デバフ・状態異常系
  debuff: Color(0xFFFF003C),
  poison: Color(0xFFBA68C8),
  recoil: Color(0xFFFF5252),
  // 6. カード属性・状態 (CardState)
  stateBurn: Color(0xFFFF003C),
  stateRecycle: Color(0xFF00F0FF),
  stateInfect: Color(0xFF8E24AA),
  stateHold: Color(0xFFFF6B00),
);

class AppTheme {
  static ThemeData get light => lightCustomTheme.buildTheme(
    ThemeData.light(useMaterial3: true),
  );

  static ThemeData get dark => darkCustomTheme.buildTheme(
    ThemeData.dark(useMaterial3: true),
  );
}

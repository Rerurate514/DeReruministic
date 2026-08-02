import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

const lightCustomTheme = AppColorScheme(
  brandColor: Color(0xFF1E88E5),
  surfaceBackground: Color(0xFFF5F5F7),
  textPrimary: Color(0xFF1D1D1F),
  costDp: Color(0xFF0288D1),
  playerHp: Color(0xFF2E7D32),
  enemyHp: Color(0xFFC62828),
  shield: Color(0xFFF57F17),
  buff: Color(0xFF1565C0),
  debuff: Color(0xFFD81B60),
  stateBurn: Color(0xFF4A148C),
);

const darkCustomTheme = AppColorScheme(
  brandColor: Color(0xFF90CAF9),
  surfaceBackground: Color(0xFF121212),
  textPrimary: Color(0xFFE0E0E0),
  costDp: Color(0xFF4FC3F7),
  playerHp: Color(0xFF81C784),
  enemyHp: Color(0xFFE57373),
  shield: Color(0xFFFFD54F),
  buff: Color(0xFF64B5F6),
  debuff: Color(0xFFF06292),
  stateBurn: Color(0xFFBA68C8),
);

class AppTheme {
  static ThemeData get light => lightCustomTheme.buildTheme(
    ThemeData.light(useMaterial3: true),
  );

  static ThemeData get dark => darkCustomTheme.buildTheme(
    ThemeData.dark(useMaterial3: true),
  );
}

import 'package:dereruministic/presentation/pages/auth/components/background/auth_background_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: AuthBackgroundPainter(context.themePalette),
      ),
    );
  }
}

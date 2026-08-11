import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class UiFilledCircle extends StatelessWidget {
  const UiFilledCircle({this.color, this.size = 8, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color ?? theme.brandSecondary,
        shape: BoxShape.circle,
      ),
    );
  }
}

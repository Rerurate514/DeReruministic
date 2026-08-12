import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class UiFilledSquare extends StatelessWidget {
  const UiFilledSquare({this.color, this.size = 8, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? theme.brandSecondary,
      ),
    );
  }
}

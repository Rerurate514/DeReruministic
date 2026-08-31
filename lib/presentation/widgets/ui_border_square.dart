import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class UiBorderSquare extends StatelessWidget {
  const UiBorderSquare({this.color, this.size = 8, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color ?? theme.brandSecondary),
        color: Colors.transparent,
      ),
    );
  }
}

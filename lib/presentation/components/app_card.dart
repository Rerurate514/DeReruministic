import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:real_liquid_glass/real_liquid_glass.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    super.key,
    this.borderRadius = 0,
    this.borderColor,
    this.borderWidth = 2,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return LiquidGlassContainer(
      shape: const LiquidGlassShape.roundedRectangle(0),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

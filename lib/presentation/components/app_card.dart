import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    super.key,
    this.borderRadius = 0,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor ?? theme.buttonSecondary, width: 2),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

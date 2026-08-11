import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    super.key,
    this.borderRadius = 0,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: theme.buttonSecondary, width: 2),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

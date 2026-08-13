import 'dart:ui';

import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    super.key,
    this.borderRadius = 0,
    this.borderColor,
    this.borderWidth = 2,
    this.background,
    this.isBlur = false,
    this.blurSigma = 4,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? background;
  final bool isBlur;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final effectiveBorderRadius = BorderRadius.circular(borderRadius);
    final effectivePadding = padding ?? const EdgeInsets.all(8);

    Widget content = Container(
      padding: effectivePadding,
      child: child,
    );

    if (isBlur) {
      content = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: content,
      );
    }

    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      color: background ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: BorderSide(
          color: borderColor ?? theme.buttonSecondary,
          width: borderWidth,
        ),
      ),
      child: content,
    );
  }
}

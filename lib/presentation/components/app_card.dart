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
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? background;
  final bool isBlur;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return Card(
      elevation: 8,
      color: background ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor ?? theme.buttonSecondary,
          width: borderWidth,
        ),
      ),
      child: isBlur
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: borderColor ?? theme.buttonSecondary,
                      width: borderWidth,
                    ),
                  ),
                  child: child,
                ),
              ),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(8),
              child: child,
            ),
    );
  }
}

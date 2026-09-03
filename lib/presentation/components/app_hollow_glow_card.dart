import 'dart:ui';

import 'package:dereruministic/presentation/painter/hollow_glow_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AppHollowGlowCard extends StatelessWidget {
  const AppHollowGlowCard({
    required this.child,
    this.color,
    this.backgroundColor,
    this.blurRadius = 2.0,
    this.spreadWidth = 5.0,
    this.borderRadius = 1000.0,
    this.blurSigma = 4.0,
    this.borderWidth = 0.1,
    this.padding,
    super.key,
  });

  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final double blurRadius;
  final double spreadWidth;
  final double borderRadius;
  final double blurSigma;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final effectiveColor = color ?? theme.brandSecondary;
    final effectiveBorderRadius = BorderRadius.circular(borderRadius);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: HollowGlowPainter(
              color: effectiveColor,
              blurRadius: blurRadius,
              spreadWidth: spreadWidth,
              borderRadius: borderRadius,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: effectiveBorderRadius,
                border: Border.all(
                  color: effectiveColor,
                  width: borderWidth,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

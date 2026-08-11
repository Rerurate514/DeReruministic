import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AppHighlightButton extends StatelessWidget {
  const AppHighlightButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.width = double.infinity,
    this.height = 48,
    this.foregroundColor,
    this.backgroundColor,
    this.isGlow = false,
    this.borderRadius = 0,
  });

  final VoidCallback onPressed;
  final Widget child;

  final double width;
  final double height;

  final Color? foregroundColor;
  final Color? backgroundColor;

  final bool isGlow;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: isGlow
            ? [
                BoxShadow(
                  color: backgroundColor ?? theme.brandColor,
                  spreadRadius: 1,
                  blurRadius: 15,
                ),
              ]
            : null,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.brandColor,
            foregroundColor: foregroundColor ?? theme.surfaceBackground,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

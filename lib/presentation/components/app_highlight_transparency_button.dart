import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AppHighlightTransparencyButton extends StatelessWidget {
  const AppHighlightTransparencyButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.width = double.infinity,
    this.height = 48,
    this.foregroundColor,
    this.backgroundColor,
  });

  final VoidCallback onPressed;
  final Widget child;

  final double width;
  final double height;

  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? theme.brandColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(color: foregroundColor ?? theme.brandColor),
          ),
        ),
        child: child,
      ),
    );
  }
}

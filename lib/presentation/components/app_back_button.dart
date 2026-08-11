import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends HookWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.primaryColor,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.size = 40.0,
  });

  final VoidCallback? onPressed;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    final effectivePrimaryColor = primaryColor ?? theme.brandColor;
    final effectiveBackgroundColor = backgroundColor ?? theme.surfaceContainer;
    final effectiveBorderColor = borderColor ?? theme.outlineVariant;
    final effectiveIconColor = iconColor ?? theme.textPrimary;

    final isHovered = useState(false);
    final isPressed = useState(false);

    final isHighlighted = isHovered.value || isPressed.value;

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTapDown: (_) => isPressed.value = true,
        onTapUp: (_) => isPressed.value = false,
        onTapCancel: () => isPressed.value = false,
        onTap:
            onPressed ??
            () {
              if (context.canPop()) {
                context.pop();
              }
            },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isHighlighted
                  ? effectivePrimaryColor
                  : effectiveBorderColor,
              width: isHighlighted ? 1.5 : 1.0,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: effectivePrimaryColor.withOpacity(0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              size: size * 0.45,
              color: isHighlighted ? effectivePrimaryColor : effectiveIconColor,
            ),
          ),
        ),
      ),
    );
  }
}

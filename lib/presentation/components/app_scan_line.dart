import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppScanLine extends HookWidget {
  const AppScanLine({
    this.duration = const Duration(seconds: 1),
    this.color,
    this.lineWidth = 2.0,
    this.blurRadius = 15.0,
    this.spreadRadius = 3.0,
    this.repeat = true,
    super.key,
  });

  final Duration duration;
  final Color? color;
  final double lineWidth;
  final double blurRadius;
  final double spreadRadius;
  final bool repeat;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final lineThemeColor = color ?? theme.brandSecondary;

    final controller = useAnimationController(
      duration: duration,
    );

    useEffect(() {
      if (repeat) {
        controller.repeat();
      } else {
        controller.forward();
      }
      return null;
    }, [controller, repeat]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final startX = -lineWidth;
            final endX = parentWidth;
            final dx = startX + (controller.value * (endX - startX));

            return Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            );
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: lineWidth,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: lineThemeColor,
                    spreadRadius: spreadRadius,
                    blurRadius: blurRadius,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

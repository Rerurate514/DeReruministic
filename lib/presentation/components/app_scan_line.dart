import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppScanLine extends HookWidget {
  const AppScanLine({
    this.direction = Axis.horizontal,
    this.duration = const Duration(seconds: 1),
    this.color,
    this.lineThickness = 2.0,
    this.blurRadius = 15.0,
    this.spreadRadius = 3.0,
    this.repeat = true,
    super.key,
  });

  final Axis direction;
  final Duration duration;
  final Color? color;
  final double lineThickness;
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
        final isHorizontal = direction == Axis.horizontal;
        final maxExtent = isHorizontal
            ? constraints.maxWidth
            : constraints.maxHeight;

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final start = -lineThickness;
            final end = maxExtent;
            final progress = start + (controller.value * (end - start));

            return Transform.translate(
              offset: isHorizontal ? Offset(progress, 0) : Offset(0, progress),
              child: child,
            );
          },
          child: Align(
            alignment: isHorizontal
                ? Alignment.centerLeft
                : Alignment.topCenter,
            child: Container(
              width: isHorizontal ? lineThickness : double.infinity,
              height: isHorizontal ? double.infinity : lineThickness,
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

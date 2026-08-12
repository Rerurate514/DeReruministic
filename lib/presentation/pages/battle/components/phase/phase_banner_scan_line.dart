import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhaseBannerScanLine extends HookWidget {
  const PhaseBannerScanLine({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    final controller = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, [controller]);

    return ClipRRect(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final dx = controller.value * 180;
          return Transform.translate(
            offset: Offset(dx, 0),
            child: child,
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.brandSecondary,
                  spreadRadius: 3,
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

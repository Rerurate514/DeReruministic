import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UiFlashingWidget extends HookWidget {
  const UiFlashingWidget({
    required this.color,
    required this.child,
    super.key,
    this.tween,
    this.duration = const Duration(seconds: 2),
  });

  final Color color;
  final Widget child;
  final Tween<double>? tween;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, [controller]);

    final flashingAnimation = useAnimation(
      (tween ??
              Tween<double>(
                begin: 1,
                end: 0,
              ))
          .animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
    );

    return Opacity(
      opacity: flashingAnimation,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppInfinityRotation extends HookWidget {
  const AppInfinityRotation({
    required this.child,
    super.key,
    this.duration = const Duration(seconds: 2),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: duration,
    )..repeat();

    return RotationTransition(
      turns: controller,
      child: child,
    );
  }
}

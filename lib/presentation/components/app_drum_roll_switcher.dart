import 'package:flutter/material.dart';

class AppDrumRollSwitcher extends StatelessWidget {
  const AppDrumRollSwitcher({
    required this.child,
    this.duration = const Duration(seconds: 1),
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (child, animation) {
          final inAnimation = Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation);

          final outAnimation = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);

          if (child.key == this.child.key) {
            return SlideTransition(
              position: inAnimation,
              child: child,
            );
          } else {
            return SlideTransition(
              position: outAnimation,
              child: child,
            );
          }
        },
        child: child,
      ),
    );
  }
}

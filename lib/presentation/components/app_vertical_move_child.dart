import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppVerticalMoveChild extends HookWidget {
  const AppVerticalMoveChild({
    required this.child,
    this.duration = const Duration(seconds: 10),
    this.begin = const Offset(0, -1),
    this.end = const Offset(0, 1),
    super.key,
  });

  final Duration duration;
  final Offset begin;
  final Offset end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: duration,
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, [controller]);

    final animation = useMemoized(
      () => Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(controller),
      [controller, begin, end],
    );

    return SlideTransition(
      position: animation,
      child: child,
    );
  }
}

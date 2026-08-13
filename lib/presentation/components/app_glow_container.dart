import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppGlowContainer extends HookWidget {
  const AppGlowContainer({
    required this.child,
    this.color,
    this.alpha = 50,
    super.key,
  });

  final Color? color;
  final int alpha;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, []);

    final topLeft = useMemoized(
      () => TweenSequence<Alignment>([
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
      ]).animate(controller),
      [controller],
    );

    final bottomRight = useMemoized(
      () => TweenSequence<Alignment>([
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25,
        ),
      ]).animate(controller),
      [controller],
    );

    return ClipRRect(
      child: Stack(
        children: [
          AlignTransition(
            alignment: topLeft,
            child: SizedBox(
              width: 8,
              height: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.brandSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: color ?? theme.brandSecondary,
                      spreadRadius: 5,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AlignTransition(
            alignment: bottomRight,
            child: SizedBox(
              width: 8,
              height: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.brandSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: color ?? theme.brandSecondary,
                      spreadRadius: 5,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}

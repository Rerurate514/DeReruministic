import 'package:dereruministic/presentation/widgets/ui_filled_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UiActiveFilledCircle extends HookWidget {
  const UiActiveFilledCircle({this.color, this.size = 8, super.key});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, [controller]);

    final opacityAnimation = useAnimation(
      useMemoized(() {
        return TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.8,
              end: 0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: ConstantTween<double>(0),
            weight: 50,
          ),
        ]).animate(controller);
      }, [controller]),
    );

    final scaleAnimation = useAnimation(
      useMemoized(() {
        return TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1,
              end: 3,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: ConstantTween<double>(3),
            weight: 50,
          ),
        ]).animate(controller);
      }, [controller]),
    );

    return Stack(
      children: [
        UiFilledCircle(
          color: color,
          size: size,
        ),
        Opacity(
          opacity: opacityAnimation,
          child: Transform.scale(
            scale: scaleAnimation,
            child: UiFilledCircle(
              color: color,
              size: size,
            ),
          ),
        ),
      ],
    );
  }
}

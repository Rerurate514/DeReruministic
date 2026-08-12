import 'package:dereruministic/presentation/widgets/ui_border_square.dart';
import 'package:dereruministic/presentation/widgets/ui_filled_square.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UiActiveFilledSquare extends HookWidget {
  const UiActiveFilledSquare({
    this.color,
    this.size = 8,
    this.isOnlyBorder = false,
    super.key,
  });

  final Color? color;
  final double size;
  final bool isOnlyBorder;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, [controller]);

    final opacityAnimation = useMemoized(
      () => TweenSequence<double>([
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
      ]).animate(controller),
      [controller],
    );

    final scaleAnimation = useMemoized(
      () => TweenSequence<double>([
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
      ]).animate(controller),
      [controller],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(
              opacity: opacityAnimation.value,
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: isOnlyBorder
              ? UiBorderSquare(
                  color: color,
                  size: size,
                )
              : UiFilledSquare(
                  color: color,
                  size: size,
                ),
        ),
        UiFilledSquare(
          color: color,
          size: size,
        ),
      ],
    );
  }
}
